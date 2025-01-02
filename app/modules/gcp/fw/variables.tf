variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy the resources"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "source_ranges" {
  description = "The source IP ranges to allow"
  type        = list(string)
  default     = []
}

variable "destination_ranges" {
  description = "The destination IP ranges to allow"
  type        = list(string)
  default     = []
}

variable "firewall_rules" {
  type = map(object({
    source_ranges      = optional(list(string), [])
    destination_ranges = optional(list(string), [])

    allow = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])

    deny = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
  }))
}
