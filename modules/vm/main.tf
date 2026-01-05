# Public IP (optional)
resource "azurerm_public_ip" "vm" {
  count               = var.public_ip_enabled ? 1 : 0
  name                = var.public_ip_name != null ? var.public_ip_name : "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Network Interface
resource "azurerm_network_interface" "vm" {
  name                = var.network_interface_name != null ? var.network_interface_name : "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_enabled ? azurerm_public_ip.vm[0].id : null
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  disable_password_authentication = var.disable_password_authentication
  admin_password                  = var.admin_password

  network_interface_ids = [azurerm_network_interface.vm.id]

  os_disk {
    name                 = var.os_disk_name != null ? var.os_disk_name : "${var.vm_name}-osdisk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication && var.public_key_path != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = file(var.public_key_path)
    }
  }
}

