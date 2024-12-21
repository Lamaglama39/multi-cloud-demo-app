module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.1"

  project_id                  = var.project_id
  disable_services_on_destroy = var.disable_services_on_destroy
  enable_apis                 = var.enable_apis
  activate_apis               = var.activate_apis
}
