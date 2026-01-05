output "vmss_id" {
  description = "ID of the virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  description = "Name of the virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "autoscale_setting_id" {
  description = "ID of the autoscale setting"
  value       = var.enable_autoscaling ? azurerm_monitor_autoscale_setting.vmss[0].id : null
}

output "autoscale_setting_name" {
  description = "Name of the autoscale setting"
  value       = var.enable_autoscaling ? azurerm_monitor_autoscale_setting.vmss[0].name : null
}

