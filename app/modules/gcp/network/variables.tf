variable "project_id" {
  description = "The project ID to deploy the resources"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string

}

variable "routing_mode" {
  description = "The routing mode of the VPC network"
  type        = string
  default     = "GLOBAL"
}

variable "subnets" {
  description = "The list of subnets to create in the VPC network"
  type = list(object({
    subnet_name           = string
    subnet_ip             = string
    subnet_region         = string
    subnet_private_access = optional(bool, false)
    subnet_flow_logs      = optional(bool, false)
    description           = optional(string, "")
  }))
}

variable "routes" {
  description = "The list of routes to create in the VPC network"
  type = list(object({
    name                   = string
    description            = string
    destination_range      = string
    tags                   = string
    next_hop_internet      = string
    next_hop_instance      = optional(string, null)
    next_hop_instance_zone = optional(string, null)
  }))
}

variable "ingress_rules" {
  description = "The list of firewall rules to create in the VPC network"
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
}
