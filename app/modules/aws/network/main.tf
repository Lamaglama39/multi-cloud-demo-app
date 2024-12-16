module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.app_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_vpn_gateway                = var.enable_vpn_gateway
  propagate_public_route_tables_vgw = var.propagate_public_route_tables_vgw
}
