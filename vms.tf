resource "outscale_security_group" "security_group_public" {
  description         = "sgpublic"
  security_group_name = "sgpublic"
  net_id              = outscale_net.net01.net_id
}

resource "outscale_security_group" "security_group_private" {
  description         = "sgprivate"
  security_group_name = "sgprivate"
  net_id              = outscale_net.net01.net_id
}

resource "outscale_security_group_rule" "security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_public.security_group_id
  from_port_range   = "22"
  to_port_range     = "22"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0" # "${var.osc_ip}"
}


resource "outscale_security_group_rule" "security_group_rule05" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_public.security_group_id
  from_port_range   = "80"
  to_port_range     = "80"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0" # "${var.osc_ip}"
}

resource "outscale_security_group_rule" "security_group_rule02" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_private.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    security_groups_members {
      security_group_id = outscale_security_group.security_group_public.security_group_id
    }
  }
}


resource "outscale_security_group_rule" "security_group_rule03" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_private.security_group_id
  rules {
    from_port_range = "80"
    to_port_range   = "80"
    ip_protocol     = "tcp"
    security_groups_members {
      security_group_id = outscale_security_group.security_group_public.security_group_id
    }
  }
}

resource "outscale_public_ip" "public_ip02" {
}

resource "outscale_vm" "vm01_public" {
  image_id           = var.omi_id
  vm_type            = var.instance_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group_public.id]
  subnet_id          = outscale_subnet.subnet_public.subnet_id
  placement_tenancy  = "default"
  user_data          = base64encode(file("./resources/haproxy-install.yml"))
  tags {
    key   = "name"
    value = "terraform-public-vm"
  }
  tags {
    key   = "osc.fcu.eip.auto-attach"
    value = outscale_public_ip.public_ip02.public_ip
  }
}



resource "outscale_vm" "vm02_private" {
  image_id           = var.omi_id
  vm_type            = var.instance_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group_private.id]
  subnet_id          = outscale_subnet.subnet_private.subnet_id
  private_ips        = ["192.168.2.100"]
  placement_tenancy  = "default"
  user_data          = base64encode(file("./resources/web-app-1.yml"))
  tags {
    key   = "name"
    value = "terraform-private-1"
  }
}


resource "outscale_vm" "vm03_private" {
  image_id           = var.omi_id
  vm_type            = var.instance_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group_private.id]
  subnet_id          = outscale_subnet.subnet_private.subnet_id
  private_ips        = ["192.168.2.200"]
  placement_tenancy  = "default"
  user_data          = base64encode(file("./resources/web-app-2.yml"))
  tags {
    key   = "name"
    value = "terraform-private-2"
  }
}



