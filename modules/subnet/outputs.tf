output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.main.id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.main.name
}

output "subnet_address_prefixes" {
  description = "Address prefixes of the subnet"
  value       = azurerm_subnet.main.address_prefixes
}

