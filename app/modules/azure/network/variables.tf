variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  type        = list(string)
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
}

variable "name" {
  description = "The name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnets" {
  description = "The subnets that are created in the virtual network"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}
