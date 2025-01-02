resource "google_compute_instance" "main" {
  project      = var.project_id
  name         = "${var.app_name}-gce"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk.image
      size  = var.boot_disk.size
      type  = var.boot_disk.type
    }
  }

  network_interface {
    network    = var.network_interface.network
    subnetwork = var.network_interface.subnetwork

    network_ip = var.network_interface.nat_ip
    dynamic "access_config" {
      for_each = var.network_interface.enable_external_ip ? [1] : []
      content {}
    }

  }

  metadata_startup_script = var.startup_script
}
