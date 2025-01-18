resource "azurerm_network_interface" "main" {
  name                = "${var.app_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip_id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_virtual_machine" "main" {
  name                          = "${var.app_name}-avm"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  network_interface_ids         = [azurerm_network_interface.main.id]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = var.delete_os_disk_on_termination


  storage_image_reference {
    publisher = var.storage_image_reference["publisher"]
    offer     = var.storage_image_reference["offer"]
    sku       = var.storage_image_reference["sku"]
    version   = var.storage_image_reference["version"]
  }

  storage_os_disk {
    name              = var.storage_os_disk["name"]
    caching           = var.storage_os_disk["caching"]
    create_option     = var.storage_os_disk["create_option"]
    managed_disk_type = var.storage_os_disk["managed_disk_type"]
  }

  os_profile {
    computer_name  = var.os_profile["computer_name"]
    admin_username = var.os_profile["admin_username"]
    custom_data    = var.os_profile["custom_data"]
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.os_profile["admin_username"]}/.ssh/authorized_keys"
      key_data = var.public_key
    }
  }
}
