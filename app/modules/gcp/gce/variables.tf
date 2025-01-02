variable "app_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "boot_disk" {
  type = object({
    image = string
    size  = optional(number, 10)
    type  = optional(string, "pd-standard")
  })
}

variable "network_interface" {
  type = object({
    network            = string
    subnetwork         = string
    nat_ip             = optional(string, null)
    enable_external_ip = optional(bool, false)
  })
}

variable "startup_script" {
  type    = string
  default = ""
}
