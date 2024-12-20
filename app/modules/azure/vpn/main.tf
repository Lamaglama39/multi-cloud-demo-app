# ngw
resource "azurerm_virtual_network_gateway" "main" {
  name                = "${var.app_name}-vgw"
  resource_group_name = var.resource_group_name
  location            = var.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  sku           = var.sku
  active_active = var.active_active
  enable_bgp    = var.enable_bgp

  ip_configuration {
    subnet_id            = var.subnet_gateway_id
    public_ip_address_id = var.public_ip_id
  }
}

# lgw
resource "azurerm_local_network_gateway" "main" {
  for_each = var.vpn_tunnels

  name                = each.value.gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  gateway_address = each.value.gateway_address
  address_space   = each.value.address_space
}

resource "azurerm_virtual_network_gateway_connection" "main" {
  for_each = var.vpn_tunnels

  name                = each.value.connection_name
  resource_group_name = var.resource_group_name
  location            = var.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id = azurerm_local_network_gateway.main[each.key].id
  shared_key = each.value.pre_shared_key
}
