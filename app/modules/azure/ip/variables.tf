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

variable "allocation_method" {
  description = "The allocation method of the public IP address"
  type        = string
  default     = "Static"
}
