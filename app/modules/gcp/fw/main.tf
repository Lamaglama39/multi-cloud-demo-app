resource "google_compute_firewall" "main" {
  for_each = var.firewall_rules

  project = var.project_id
  name    = "${var.app_name}-${each.key}-fw"
  network = var.network_name

  source_ranges      = lookup(each.value, "source_ranges", [])
  destination_ranges = lookup(each.value, "destination_ranges", [])

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}
