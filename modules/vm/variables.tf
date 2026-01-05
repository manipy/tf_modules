variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
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
  description = "Admin password for the virtual machine"
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
  description = "Path to the public SSH key file"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "public_ip_enabled" {
  description = "Enable public IP address for the VM"
  type        = bool
  default     = true
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = null
}

variable "network_interface_name" {
  description = "Name of the network interface"
  type        = string
  default     = null
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
  default     = null
}

variable "os_disk_caching" {
  description = "Caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "image_publisher" {
  description = "Publisher of the image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Version of the image"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

