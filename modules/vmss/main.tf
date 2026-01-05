# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vm_sku
  instances           = var.instances
  upgrade_mode        = var.upgrade_mode
  tags                = var.tags

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication

  health_probe_id = var.health_probe_id

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.load_balancer_backend_pool_ids
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication && var.public_key_path != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = file(var.public_key_path)
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

# Autoscale Setting
resource "azurerm_monitor_autoscale_setting" "vmss" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "${var.vmss_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  enabled             = true
  tags                = var.tags

  profile {
    name = "default"

    capacity {
      default = var.autoscale_default_instances
      minimum = var.autoscale_min_instances
      maximum = var.autoscale_max_instances
    }

    # Default rule: Scale out when CPU is above 70%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    # Default rule: Scale in when CPU is below 30%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  # Notification (optional - can be extended)
  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
    }
  }
}

