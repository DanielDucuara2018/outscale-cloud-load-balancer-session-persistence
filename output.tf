output "vm01_public_ip" {
  value = outscale_vm.vm01_public.public_ip
}

output "vm01_public_id" {
  value = outscale_vm.vm01_public.id
}

output "vm02_private_ip" {
  value = outscale_vm.vm02_private.private_ip
}

output "vm02_private_id" {
  value = outscale_vm.vm02_private.id
}


output "vm03_private_ip" {
  value = outscale_vm.vm03_private.private_ip
}


output "vm03_private_id" {
  value = outscale_vm.vm03_private.id
}

output "sg_lb" {
  value = outscale_security_group.security_group_lb.security_group_id
}

output "private_subnet" {
  value = outscale_subnet.subnet_private.subnet_id

}
