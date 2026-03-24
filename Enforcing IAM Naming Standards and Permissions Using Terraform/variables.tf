variable "KKE_PROJECT" {
  type        = string
  description = "Name of the project"
  validation {
    condition     = length(var.KKE_PROJECT) > 0
    error_message = "Project name cannot be empty"
  }
}

variable "KKE_TEAM" {
  type        = string
  description = "Name of the team (letters, digits, dash, underscore allowed)"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.KKE_TEAM))
    error_message = "Team name must only contain letters, digits, dash or underscore"
  }
}

variable "KKE_ENVIRONMENT" {
  type        = string
  description = "Environment name (dev, prod, etc)"
}
