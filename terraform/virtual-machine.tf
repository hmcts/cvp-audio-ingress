#---------------------------------------------------
# VMs
#---------------------------------------------------

resource "azurerm_linux_virtual_machine" "wowza_vm" {
  count = var.vm_count

  name = "${local.service_name}-vm${count.index + 1}"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  zone = count.index + 1

  size           = var.vm_size
  admin_username = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.wowza_nic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = data.azurerm_key_vault_secret.ssh_pub_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  provision_vm_agent = true

  custom_data = data.template_cloudinit_config.wowza_setup.rendered

  source_image_reference {
    publisher = var.wowza_publisher
    offer     = var.wowza_offer
    sku       = var.wowza_sku
    version   = var.wowza_version
  }

  plan {
    name      = var.wowza_sku
    product   = var.wowza_offer
    publisher = var.wowza_publisher
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  tags = module.ctags.common_tags
}
