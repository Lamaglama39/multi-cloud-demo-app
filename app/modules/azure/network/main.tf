module "avm-res-network-virtualnetwork" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"

  address_space       = var.address_space
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  subnets             = var.subnets
}
