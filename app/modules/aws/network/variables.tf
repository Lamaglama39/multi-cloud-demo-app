variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "The availability zones for the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  default     = []
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  default     = []
  type        = list(string)
}

variable "enable_vpn_gateway" {
  description = "value to enable VPN gateway"
  default     = true
  type        = bool
}

variable "propagate_public_route_tables_vgw" {
  description = "value to propagate public route tables to VGW"
  default     = true
  type        = bool
}


