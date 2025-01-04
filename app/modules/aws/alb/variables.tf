variable "app_name" {
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "alb_subnet" {
  type = list(string)
}

variable "alb_security_groups" {
  type = list(string)
}

variable "path_config" {
  description = "Configuration for path-based routing"
  type = map(object({
    ip                = string
    priority          = number
    availability_zone = string
  }))
}
