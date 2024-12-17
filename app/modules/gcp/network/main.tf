module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode

  subnets       = var.subnets
  routes        = var.routes
  ingress_rules = var.ingress_rules
}
