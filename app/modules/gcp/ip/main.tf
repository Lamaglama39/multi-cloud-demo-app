resource "google_compute_address" "main" {
  project = var.project_id
  name    = "${var.app_name}-pip"
  region  = var.region
}
