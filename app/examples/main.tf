##################################################
# aws
##################################################
module "aws_vpc" {
  source = "../modules/aws/network"

  app_name       = local.app_name
  cidr           = local.aws_cidr
  azs            = local.aws_azs
  public_subnets = local.aws_public_subnets
}

module "aws_azure_vpn" {
  source = "../modules/aws/vpn"

  app_name           = "${local.app_name}-azure"
  ip_address         = module.azure_public_ip.azurerm_public_ip.ip_address
  vpn_gateway_id     = module.aws_vpc.vpc.vgw_id
  address_space      = local.azure_cidr
}

module "aws_gcp_vpn" {
  source = "../modules/aws/vpn"

  app_name           = "${local.app_name}-gcp"
  ip_address         = module.gcp_public_ip.google_compute_address.address
  vpn_gateway_id     = module.aws_vpc.vpc.vgw_id
  address_space      = [local.gcp_subnets[0].subnet_ip]
}

module "aws_sg" {
  source = "../modules/aws/sg/group"

  for_each        = local.security_groups
  app_name        = local.app_name
  vpc_id          = module.aws_vpc.vpc.vpc_id
  security_groups = each.value
}

module "aws_sg_rule" {
  source = "../modules/aws/sg/rule"

  for_each   = local.sg_rules
  app_name   = local.app_name
  vpc_id     = module.aws_vpc.vpc.vpc_id
  sg_rules   = each.value
  depends_on = [module.aws_sg]
}

module "aws_alb" {
  source = "../modules/aws/alb"

  app_name = local.app_name
  vpc_id   = module.aws_vpc.vpc.vpc_id

  alb_subnet          = module.aws_vpc.vpc.public_subnets
  alb_security_groups = [module.aws_sg.alb.sg.id]
  path_config         = local.path_config
}

module "aws_key_pair" {
  source = "../modules/aws/key_pair"

  app_name         = local.app_name
  key_algorithm    = local.key_algorithm
  private_key_file = local.private_key_file
}

module "aws_iam_role" {
  source = "../modules/aws/iam"

  app_name                 = local.app_name
  trusted_role_services    = local.trusted_role_services
  instance_iam_policy_arns = local.instance_iam_policy_arns
}

module "aws_ec2" {
  source = "../modules/aws/ec2"

  app_name               = local.app_name
  vpc_id                 = module.aws_vpc.vpc.vpc_id
  subnet_id              = module.aws_vpc.vpc.public_subnets[0]
  vpc_security_group_ids = [module.aws_sg.ec2.sg.id]
  iam_role               = module.aws_iam_role.iam_role.iam_instance_profile_name
  key_name               = module.aws_key_pair.key_pair.key_pair_name

  server_instances_map = local.instances
  depends_on           = [module.aws_vpc]
}

module "aws_cdn" {
  source          = "../modules/aws/cloudfront"
  app_name        = local.app_name
  alb_domain_name = module.aws_alb.alb.dns_name
}


##################################################
# azure
##################################################
module "azure_resource_group" {
  source = "../modules/azure/rg"

  app_name = local.app_name
  location = local.azure_region
}

module "azure_vnet" {
  source = "../modules/azure/network"

  app_name            = local.app_name
  address_space       = local.azure_cidr
  location            = local.azure_region
  name                = "${local.app_name}-vnet"
  resource_group_name = module.azure_resource_group.resource_group.name
  subnets             = local.azure_subnets
}

module "azure_public_ip" {
  source = "../modules/azure/ip"

  app_name            = local.app_name
  location            = local.azure_region
  resource_group_name = module.azure_resource_group.resource_group.name
}

module "azure_vpn" {
  source = "../modules/azure/vpn"

  app_name            = local.app_name
  location            = local.azure_region
  resource_group_name = module.azure_resource_group.resource_group.name
  subnet_gateway_id   = module.azure_vnet.vpc.subnets.subnet2.resource.id
  public_ip_id        = module.azure_public_ip.azurerm_public_ip.id
  vpn_tunnels         = local.azure_vpn_tunnels
}

module "azure_nsg" {
  source = "../modules/azure/nsg"

  app_name            = local.app_name
  location            = local.azure_region
  resource_group_name = module.azure_resource_group.resource_group.name
  allowed_cidr        = local.current-ip
}

module "azure_public_ip_avm" {
  source = "../modules/azure/ip"

  app_name            = "${local.app_name}-avm"
  location            = local.azure_region
  resource_group_name = module.azure_resource_group.resource_group.name
}

module "azure_avm" {
  source = "../modules/azure/avm"

  app_name                  = local.app_name
  location                  = local.azure_region
  resource_group_name       = module.azure_resource_group.resource_group.name
  subnet_id                 = module.azure_vnet.vpc.subnets.subnet1.resource_id
  network_security_group_id = module.azure_nsg.nsg.id
  vm_size                   = local.azure_vm_size
  storage_image_reference   = local.azure_storage_image_reference
  storage_os_disk           = local.azure_storage_os_disk
  os_profile                = local.azure_os_profile
  public_ip_id              = module.azure_public_ip_avm.azurerm_public_ip.id
  private_ip_address        = local.azure_private_ip_address
  public_key                = module.aws_key_pair.public_key
}


##################################################
# google cloud
##################################################
module "gcp_apis" {
  source = "../modules/gcp/apis"

  project_id    = local.google_project_id
  activate_apis = local.activate_apis
}

module "gcp_vpc" {
  source = "../modules/gcp/network"

  project_id   = local.google_project_id
  network_name = local.app_name
  routing_mode = "GLOBAL"

  subnets       = local.gcp_subnets
  routes        = local.gcp_routes
  ingress_rules = local.gcp_ingress_rules
}

module "gcp_public_ip" {
  source = "../modules/gcp/ip"

  app_name   = local.app_name
  project_id = local.google_project_id
  region     = local.google_region
  depends_on = [module.gcp_vpc]
}

resource "time_sleep" "wait_apis" {
  depends_on = [module.gcp_apis]

  create_duration = "180s"
}

module "gcp_vpn" {
  source = "../modules/gcp/vpn"

  app_name     = local.app_name
  project_id   = local.google_project_id
  region       = local.google_region
  network_name = local.app_name
  ip_address   = module.gcp_public_ip.google_compute_address.address
  vpn_tunnels  = local.gcp_vpn_tunnels
  vpn_routes   = local.gcp_vpn_routes

  depends_on = [time_sleep.wait_apis]
}

module "gcp_fw" {
  source = "../modules/gcp/fw"

  project_id     = local.google_project_id
  network_name   = local.app_name
  app_name       = local.app_name
  firewall_rules = local.gcp_firewall_rules
}

module "gcp_gce" {
  source     = "../modules/gcp/gce"
  project_id = local.google_project_id
  zone       = local.gce_zone
  app_name   = local.app_name

  machine_type      = local.gce_machine_type
  boot_disk         = local.gce_boot_disk
  network_interface = local.gce_network_interface

  startup_script = local.gce_startup_script
}
