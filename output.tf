output "vm01_public_ip" {
  value = outscale_public_ip.public_ip02.public_ip
}

output "vm02_private" {
  value = outscale_vm.vm02_private.private_ip
}

output "vm03_private" {
  value = outscale_vm.vm03_private.private_ip
}
