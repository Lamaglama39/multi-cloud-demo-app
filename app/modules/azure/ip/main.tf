resource "azurerm_public_ip" "main" {
  name                = "${var.app_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
}
