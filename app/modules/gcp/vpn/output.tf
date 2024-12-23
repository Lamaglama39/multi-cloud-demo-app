output "google_compute_vpn_gateway" {
  value = google_compute_vpn_gateway.main
}

output "google_compute_forwarding_rule_esp" {
  value = google_compute_forwarding_rule.vpn_forwarding_rule_esp
}

output "google_compute_forwarding_rule_udp500" {
  value = google_compute_forwarding_rule.vpn_forwarding_rule_udp500
}

output "google_compute_forwarding_rule_udp4500" {
  value = google_compute_forwarding_rule.vpn_forwarding_rule_udp4500
}

output "google_compute_vpn_tunnel" {
  value = google_compute_vpn_tunnel.main
}
