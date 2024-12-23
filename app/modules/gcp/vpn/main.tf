# Classic VPN Gateway
resource "google_compute_vpn_gateway" "main" {
  name    = "${var.app_name}-vpn-gateway"
  project = var.project_id
  region  = var.region
  network = var.network_name
}

# firewall
resource "google_compute_forwarding_rule" "vpn_forwarding_rule_esp" {
  name        = "${var.app_name}-forwarding-rule-esp"
  project     = var.project_id
  region      = var.region
  ip_protocol = "ESP"
  ip_address  = var.ip_address
  target      = google_compute_vpn_gateway.main.self_link
}

resource "google_compute_forwarding_rule" "vpn_forwarding_rule_udp500" {
  name        = "${var.app_name}-forwarding-rule-udp500"
  project     = var.project_id
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = var.ip_address
  target      = google_compute_vpn_gateway.main.self_link
}

resource "google_compute_forwarding_rule" "vpn_forwarding_rule_udp4500" {
  name        = "${var.app_name}-forwarding-rule-udp4500"
  project     = var.project_id
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = var.ip_address
  target      = google_compute_vpn_gateway.main.self_link
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "main" {
  for_each = var.vpn_tunnels

  name               = each.key
  project            = var.project_id
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.main.self_link
  shared_secret      = each.value.shared_secret
  peer_ip            = each.value.peer_ip

  remote_traffic_selector = each.value.remote_traffic_selectors
  local_traffic_selector  = each.value.local_traffic_selectors

  depends_on = [google_compute_forwarding_rule.vpn_forwarding_rule_esp, google_compute_forwarding_rule.vpn_forwarding_rule_udp500, google_compute_forwarding_rule.vpn_forwarding_rule_udp4500]
}

# Static Routes for VPN
resource "google_compute_route" "vpn_routes" {
  for_each = var.vpn_routes

  name                = each.key
  project             = var.project_id
  network             = var.network_name
  dest_range          = each.value.dest_range
  priority            = each.value.priority
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.main[each.value.vpn_tunnel].self_link

  depends_on = [google_compute_vpn_tunnel.main]
}
