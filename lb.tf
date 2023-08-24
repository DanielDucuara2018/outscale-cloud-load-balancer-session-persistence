resource "outscale_security_group" "security_group_lb" {
  description         = "Terraform security group for internal load balancer"
  security_group_name = "terraform-security-group-for-internal-load-balancer"
  net_id              = outscale_net.net01.net_id
  tags {
      key   = "Name"
      value = "terraform-security-group-for-internal-load-balancer"
  }
}

resource "outscale_load_balancer" "load_balancer03" {
  load_balancer_name = "terraform-balancer"
  listeners {
      backend_port           = 80
      backend_protocol       = "HTTP"
      load_balancer_protocol = "HTTP"
      load_balancer_port     = 80
  }

  subnets            = [outscale_subnet.subnet_private.subnet_id]
  load_balancer_type = "internet-facing"
  tags {
      key   = "name"
      value = "terraform-alancer"
  }
  security_groups    = [outscale_security_group.security_group_lb.security_group_id]
  depends_on         = [outscale_route.route01]
}


resource "outscale_load_balancer_vms" "outscale_load_balancer_vms01" {
    load_balancer_name = "terraform-balancer"
    backend_vm_ids     = [outscale_vm.vm02_private.vm_id,outscale_vm.vm03_private.vm_id]
}

resource "outscale_security_group_rule" "security_group_rule03_lb" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_private.security_group_id
  rules {
    from_port_range   = "80"
    to_port_range     = "80"
    ip_protocol       = "tcp"
    security_groups_members {
      security_group_id = outscale_security_group.security_group_lb.security_group_id
    }
  }
}

resource "outscale_security_group_rule" "security_group_rule04_lb" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group_lb.security_group_id
  from_port_range   = "80"
  to_port_range     = "80"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0"
}