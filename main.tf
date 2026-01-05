terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Network Module
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# NSG Module
module "nsg" {
  source = "./modules/nsg"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  nsg_name            = var.nsg_name
  security_rules      = var.nsg_security_rules
  tags                = var.tags
}

# Subnet Module
module "subnet" {
  source = "./modules/subnet"

  resource_group_name        = azurerm_resource_group.main.name
  vnet_name                  = module.network.vnet_name
  subnet_name                = var.subnet_name
  address_prefixes           = var.subnet_address_prefixes
  network_security_group_id  = module.nsg.nsg_id
  tags                       = var.tags
}

# VM Module (optional - only created if deploy_vmss is false)
module "vm" {
  count  = var.deploy_vmss ? 0 : 1
  source = "./modules/vm"

  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  vm_name                         = var.vm_name
  vm_size                         = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  public_key_path                 = var.public_key_path
  subnet_id                       = module.subnet.subnet_id
  public_ip_enabled               = var.public_ip_enabled
  tags                            = var.tags
}

# VMSS Module (optional - only created if deploy_vmss is true)
module "vmss" {
  count  = var.deploy_vmss ? 1 : 0
  source = "./modules/vmss"

  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  vmss_name                       = var.vmss_name
  vm_sku                          = var.vmss_vm_sku
  instances                       = var.vmss_instances
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  public_key_path                 = var.public_key_path
  subnet_id                       = module.subnet.subnet_id
  enable_autoscaling              = var.vmss_enable_autoscaling
  autoscale_min_instances         = var.vmss_autoscale_min_instances
  autoscale_max_instances         = var.vmss_autoscale_max_instances
  autoscale_default_instances     = var.vmss_autoscale_default_instances
  upgrade_mode                    = var.vmss_upgrade_mode
  tags                            = var.tags
}

