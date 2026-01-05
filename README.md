# Azure Virtual Machine Terraform Modules

This repository contains modular Terraform code to deploy virtual machines or Virtual Machine Scale Sets (VMSS) in Azure with all dependent services including virtual network, subnets, network security groups, and autoscaling capabilities.

## Architecture

The infrastructure is organized into separate modules:

- **Network Module** (`modules/network`): Creates an Azure Virtual Network (VNet)
- **NSG Module** (`modules/nsg`): Creates a Network Security Group with configurable rules
- **Subnet Module** (`modules/subnet`): Creates a subnet and associates it with the NSG
- **VM Module** (`modules/vm`): Creates a Linux virtual machine with network interface and optional public IP

## Prerequisites

- Azure subscription
- Terraform >= 1.0
- Azure CLI installed and configured (or service principal credentials)
- SSH key pair (if using SSH authentication)

## Quick Start

1. **Clone or navigate to this directory**

2. **Copy the example variables file:**
   ```bash
   copy terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars` with your values:**
   - Update `resource_group_name`
   - Set `location` to your preferred Azure region
   - Configure `admin_username` and `public_key_path` (or `admin_password` if using password auth)
   - Adjust other variables as needed

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Plan the deployment:**
   ```bash
   terraform plan
   ```

6. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## Module Structure

```
.
├── main.tf                 # Root module that combines all sub-modules
├── variables.tf            # Root module variables
├── outputs.tf              # Root module outputs
├── terraform.tfvars.example # Example variables file
├── README.md               # This file
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── subnet/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── nsg/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── vm/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── vmss/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Usage

### Using the Root Module

The root module (`main.tf`) provides a complete example that combines all modules. Simply configure your `terraform.tfvars` file and run `terraform apply`.

### Using Individual Modules

You can also use the modules independently:

```hcl
module "network" {
  source = "./modules/network"

  resource_group_name = "my-rg"
  location            = "eastus"
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
}

module "nsg" {
  source = "./modules/nsg"

  resource_group_name = "my-rg"
  location            = "eastus"
  nsg_name            = "my-nsg"
  security_rules      = [...]
}

module "subnet" {
  source = "./modules/subnet"

  resource_group_name       = "my-rg"
  vnet_name                 = module.network.vnet_name
  subnet_name               = "my-subnet"
  address_prefixes          = ["10.0.1.0/24"]
  network_security_group_id = module.nsg.nsg_id
}

module "vm" {
  source = "./modules/vm"

  resource_group_name             = "my-rg"
  location                        = "eastus"
  vm_name                         = "my-vm"
  admin_username                  = "adminuser"
  disable_password_authentication = true
  public_key_path                 = "~/.ssh/id_rsa.pub"
  subnet_id                       = module.subnet.subnet_id
}

module "vmss" {
  source = "./modules/vmss"

  resource_group_name             = "my-rg"
  location                        = "eastus"
  vmss_name                       = "my-vmss"
  admin_username                  = "adminuser"
  disable_password_authentication = true
  public_key_path                 = "~/.ssh/id_rsa.pub"
  subnet_id                       = module.subnet.subnet_id
  enable_autoscaling              = true
  autoscale_min_instances         = 2
  autoscale_max_instances         = 10
}
```

## VMSS and Autoscaling

The VMSS module includes built-in autoscaling capabilities. When `deploy_vmss = true`, you can enable autoscaling with configurable min/max instances and default scaling rules based on CPU utilization:

- **Scale Out**: Triggers when average CPU exceeds 70% for 5 minutes
- **Scale In**: Triggers when average CPU falls below 30% for 5 minutes

Configure autoscaling in your `terraform.tfvars`:

```hcl
deploy_vmss                      = true
vmss_enable_autoscaling         = true
vmss_autoscale_min_instances    = 2
vmss_autoscale_max_instances    = 10
vmss_autoscale_default_instances = 2
```

The autoscaling rules monitor CPU metrics and automatically adjust the number of VM instances based on workload demands.

## Authentication Options

### SSH Key Authentication (Recommended)

Set `disable_password_authentication = true` and provide the path to your public SSH key:

```hcl
disable_password_authentication = true
public_key_path                = "~/.ssh/id_rsa.pub"
admin_username                 = "azureuser"
```

### Password Authentication

Set `disable_password_authentication = false` and provide a password:

```hcl
disable_password_authentication = false
admin_password                  = "YourSecurePassword123!"
admin_username                  = "azureuser"
```

## Variables

See `variables.tf` for detailed variable descriptions. Key variables include:

- `resource_group_name`: Name of the Azure resource group
- `location`: Azure region (e.g., "eastus", "westus2")
- `vnet_name`: Virtual network name
- `vnet_address_space`: VNet address space (CIDR notation)
- `subnet_name`: Subnet name
- `subnet_address_prefixes`: Subnet address prefixes
- `nsg_name`: Network Security Group name
- `nsg_security_rules`: List of NSG security rules
- `deploy_vmss`: Deploy VMSS instead of single VM (boolean)
- `vm_name`: Virtual machine name
- `vm_size`: VM size (e.g., "Standard_B2s")
- `vmss_name`: Virtual Machine Scale Set name
- `vmss_vm_sku`: SKU size for VMs in the scale set
- `vmss_instances`: Initial number of instances
- `vmss_enable_autoscaling`: Enable autoscaling for VMSS
- `vmss_autoscale_min_instances`: Minimum instances for autoscaling
- `vmss_autoscale_max_instances`: Maximum instances for autoscaling
- `admin_username`: Admin username
- `public_key_path`: Path to SSH public key file
- `public_ip_enabled`: Enable/disable public IP address

## Outputs

The root module outputs:

- `resource_group_name`: Resource group name
- `vnet_id`: Virtual network ID
- `vnet_name`: Virtual network name
- `subnet_id`: Subnet ID
- `nsg_id`: Network Security Group ID
- `vm_id`: Virtual machine ID (only if deploy_vmss is false)
- `vm_name`: Virtual machine name (only if deploy_vmss is false)
- `vm_private_ip_address`: VM private IP address (only if deploy_vmss is false)
- `vm_public_ip_address`: VM public IP address (if enabled, only if deploy_vmss is false)
- `vmss_id`: Virtual Machine Scale Set ID (only if deploy_vmss is true)
- `vmss_name`: Virtual Machine Scale Set name (only if deploy_vmss is true)
- `autoscale_setting_id`: Autoscale setting ID (only if deploy_vmss is true and autoscaling is enabled)

## Security Considerations

1. **SSH Keys**: Prefer SSH key authentication over passwords
2. **NSG Rules**: Restrict source_address_prefix in NSG rules to specific IPs when possible
3. **Public IPs**: Consider disabling public IPs if the VM doesn't need direct internet access
4. **Tags**: Use tags for resource organization and cost tracking
5. **Secrets**: Never commit sensitive values (passwords, keys) to version control

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Contributing

Feel free to customize and extend these modules for your specific needs.

## License

This code is provided as-is for educational and production use.

