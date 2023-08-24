resource "outscale_net" "net01" {
  ip_range = "${var.net_ip_range}"
  tenancy  = "default"
}

resource "outscale_subnet" "subnet_public" {
  net_id = outscale_net.net01.net_id
  ip_range = "${var.subnet_ip_range_public}"
  subregion_name = "${var.region}a"
}

resource "outscale_subnet" "subnet_private" {
  net_id = outscale_net.net01.net_id
  ip_range = "${var.subnet_ip_range_private}"
  subregion_name = "${var.region}a"
}

resource "outscale_internet_service" "internet_service01" {
}

resource "outscale_internet_service_link" "internet_service_link01" {
  internet_service_id = outscale_internet_service.internet_service01.internet_service_id
  net_id              = outscale_net.net01.net_id
}


resource "outscale_route_table" "route_table_public" {
  net_id     = outscale_net.net01.net_id
  depends_on = [outscale_subnet.subnet_private, outscale_subnet.subnet_public]
}

resource "outscale_route_table_link" "route_table_link_public" {
  subnet_id      = outscale_subnet.subnet_public.subnet_id
  route_table_id = outscale_route_table.route_table_public.route_table_id
}

resource "outscale_route" "route01" {
  gateway_id           = outscale_internet_service.internet_service01.internet_service_id
  destination_ip_range = "0.0.0.0/0"
  route_table_id       = outscale_route_table.route_table_public.route_table_id
}


resource "outscale_public_ip" "public_ip01" {
}

resource "outscale_nat_service" "nat_service01" {
  subnet_id    = outscale_subnet.subnet_public.subnet_id
  public_ip_id = outscale_public_ip.public_ip01.public_ip_id
  depends_on   = [outscale_route.route01]
}

resource "outscale_route_table" "route_table_private" {
  net_id     = outscale_net.net01.net_id
  depends_on = [outscale_subnet.subnet_private, outscale_subnet.subnet_public]
}

resource "outscale_route_table_link" "route_table_link_private" {
  subnet_id      = outscale_subnet.subnet_private.subnet_id
  route_table_id = outscale_route_table.route_table_private.route_table_id
}

resource "outscale_route" "route02" {
  nat_service_id = outscale_nat_service.nat_service01.nat_service_id
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.route_table_private.route_table_id
}

