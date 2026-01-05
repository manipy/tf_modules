output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = module.subnet.subnet_id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = module.nsg.nsg_id
}

output "vm_id" {
  description = "ID of the virtual machine (only if deploy_vmss is false)"
  value       = var.deploy_vmss ? null : module.vm[0].vm_id
}

output "vm_name" {
  description = "Name of the virtual machine (only if deploy_vmss is false)"
  value       = var.deploy_vmss ? null : module.vm[0].vm_name
}

output "vm_private_ip_address" {
  description = "Private IP address of the virtual machine (only if deploy_vmss is false)"
  value       = var.deploy_vmss ? null : module.vm[0].vm_private_ip_address
}

output "vm_public_ip_address" {
  description = "Public IP address of the virtual machine (only if deploy_vmss is false)"
  value       = var.deploy_vmss ? null : module.vm[0].vm_public_ip_address
}

output "vmss_id" {
  description = "ID of the virtual machine scale set (only if deploy_vmss is true)"
  value       = var.deploy_vmss ? module.vmss[0].vmss_id : null
}

output "vmss_name" {
  description = "Name of the virtual machine scale set (only if deploy_vmss is true)"
  value       = var.deploy_vmss ? module.vmss[0].vmss_name : null
}

output "autoscale_setting_id" {
  description = "ID of the autoscale setting (only if deploy_vmss is true and autoscaling is enabled)"
  value       = var.deploy_vmss && var.vmss_enable_autoscaling ? module.vmss[0].autoscale_setting_id : null
}

