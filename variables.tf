variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-main"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-main"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "nsg-main"
}

variable "nsg_security_rules" {
  description = "List of security rules for the NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    description                = optional(string)
  }))
  default = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow SSH access"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow HTTP access"
    }
  ]
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-linux"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for the virtual machine (required if disable_password_authentication is false)"
  type        = string
  sensitive   = true
  default     = null
}

variable "disable_password_authentication" {
  description = "Disable password authentication (use SSH keys instead)"
  type        = bool
  default     = true
}

variable "public_key_path" {
  description = "Path to the public SSH key file (required if disable_password_authentication is true)"
  type        = string
  default     = null
}

variable "public_ip_enabled" {
  description = "Enable public IP address for the VM"
  type        = bool
  default     = true
}

# VMSS Configuration
variable "deploy_vmss" {
  description = "Deploy Virtual Machine Scale Set instead of single VM"
  type        = bool
  default     = false
}

variable "vmss_name" {
  description = "Name of the virtual machine scale set"
  type        = string
  default     = "vmss-linux"
}

variable "vmss_vm_sku" {
  description = "SKU size for VMs in the scale set"
  type        = string
  default     = "Standard_B2s"
}

variable "vmss_instances" {
  description = "Initial number of instances in the scale set"
  type        = number
  default     = 2
}

variable "vmss_enable_autoscaling" {
  description = "Enable autoscaling for the VMSS"
  type        = bool
  default     = true
}

variable "vmss_autoscale_min_instances" {
  description = "Minimum number of instances for autoscaling"
  type        = number
  default     = 2
}

variable "vmss_autoscale_max_instances" {
  description = "Maximum number of instances for autoscaling"
  type        = number
  default     = 10
}

variable "vmss_autoscale_default_instances" {
  description = "Default number of instances for autoscaling"
  type        = number
  default     = 2
}

variable "vmss_upgrade_mode" {
  description = "Upgrade mode for the scale set (Automatic, Manual, Rolling)"
  type        = string
  default     = "Automatic"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "TerraformModules"
  }
}

