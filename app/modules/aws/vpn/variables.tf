variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "bgp_asn" {
  description = "The BGP ASN"
  type        = number
  default     = 65000
}

variable "ip_address" {
  description = "The IP address of the customer gateway"
  type        = string
}

variable "type" {
  description = "The type of the customer gateway"
  type        = string
  default     = "ipsec.1"
}

variable "vpn_gateway_id" {
  description = "The ID of the VPN gateway"
  type        = string
}

variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes only"
  type        = bool
  default     = true
}

variable "address_space" {
  description = "The address space of the VPN connection"
  type        = list(string)
  default     = []
}
