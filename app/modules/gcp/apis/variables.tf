variable "project_id" {
  description = "The project ID to deploy the resources"
  type        = string
}

variable "disable_services_on_destroy" {
  description = "Whether to disable services on destroy"
  type        = bool
  default     = false
}

variable "enable_apis" {
  description = "The list of APIs to enable in the project"
  type        = bool
  default     = true
}

variable "activate_apis" {
  description = "The list of APIs to activate in the project"
  type        = list(string)
}
