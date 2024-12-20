variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku" {
  description = "The SKU of the virtual network gateway"
  type        = string
  default     = "VpnGw1"
}

variable "active_active" {
  description = "Whether the virtual network gateway is active-active"
  type        = bool
  default     = false
}

variable "enable_bgp" {
  description = "Whether BGP is enabled"
  type        = bool
  default     = false
}

variable "subnet_gateway_id" {
  description = "The ID of the subnet where the VPN gateway is created"
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the public IP address"
  type        = string
}

variable "vpn_tunnels" {
  description = "The VPN tunnels"
  type = map(object({
    gateway_name    = string
    gateway_address = string
    connection_name = string
    pre_shared_key  = string
    address_space   = list(string)
  }))
}
