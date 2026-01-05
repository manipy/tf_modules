variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vmss_name" {
  description = "Name of the virtual machine scale set"
  type        = string
}

variable "vm_sku" {
  description = "SKU size for the virtual machines in the scale set"
  type        = string
  default     = "Standard_B2s"
}

variable "instances" {
  description = "Initial number of instances in the scale set"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
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
  description = "ID of the subnet where the VMSS will be deployed"
  type        = string
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

variable "upgrade_mode" {
  description = "Upgrade mode for the scale set (Automatic, Manual, Rolling)"
  type        = string
  default     = "Automatic"
}

variable "health_probe_id" {
  description = "ID of the load balancer health probe (optional)"
  type        = string
  default     = null
}

variable "load_balancer_backend_pool_ids" {
  description = "IDs of load balancer backend address pools (optional)"
  type        = list(string)
  default     = []
}

# Autoscaling variables
variable "enable_autoscaling" {
  description = "Enable autoscaling for the VMSS"
  type        = bool
  default     = true
}

variable "autoscale_min_instances" {
  description = "Minimum number of instances for autoscaling"
  type        = number
  default     = 2
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscaling"
  type        = number
  default     = 10
}

variable "autoscale_default_instances" {
  description = "Default number of instances for autoscaling"
  type        = number
  default     = 2
}


variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

