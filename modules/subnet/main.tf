resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
  tags                 = var.tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count                     = var.network_security_group_id != null ? 1 : 0
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = var.network_security_group_id
}

