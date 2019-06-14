output "id" {
  description = "Virtual Machine resourceId"
  value       = "${azurerm_virtual_machine.vm.id}"
}

output "nsg_id" {
  description = "Network Security Group resourceId"
  value       = "${azurerm_network_security_group.vm.id}"
}

output "nic_id" {
  description = "VM NIC resourceId"
  value       = "${azurerm_network_interface.vm.id}"
}

output "ip_address" {
  description = "Private IP address for the VM NIC."
  value       = "${azurerm_network_interface.vm.private_ip_address}"
}

output "pip_id" {
  description = "Public IP address resourceId"
  value       = "${azurerm_public_ip.vm.*.id}"
}

output "pip_address" {
  description = "Public IP address"
  value       = "${azurerm_public_ip.vm.*.ip_address}"
}

output "fqdn" {
  description = "Fully qualified domain name for the public IP"
  value       = "${azurerm_public_ip.vm.*.fqdn}"
}