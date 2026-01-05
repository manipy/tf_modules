output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "vm_public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = var.public_ip_enabled ? azurerm_public_ip.vm[0].ip_address : null
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.vm.id
}

