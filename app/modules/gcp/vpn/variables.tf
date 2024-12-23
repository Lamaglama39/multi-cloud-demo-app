variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy the resources"
  type        = string
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "ip_address" {
  description = "The IP address for the VPN gateway"
  type        = string
}

variable "vpn_tunnels" {
  type = map(object({
    shared_secret            = string
    peer_ip                  = string
    remote_traffic_selectors = list(string)
    local_traffic_selectors  = list(string)
  }))
}

variable "vpn_routes" {
  type = map(object({
    name        = string
    dest_range  = string
    priority    = optional(number, 1000)        # デフォルトの優先度
    vpn_tunnel  = string                        # どのVPNトンネルを使用するか
    description = optional(string, "VPN route") # オプション
    tags        = optional(list(string), [])    # タグのデフォルト値
  }))
}
