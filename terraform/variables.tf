variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "environment_name" {
  description = "Name of the environment to deploy"
  type        = string

  validation {
    condition = contains(
      ["dev", "test"],
      var.environment_name
    )

    error_message = "environment_name must be one of: dev or test."
  }
}

variable "config" {
  description = "Environment-specific configuration"

  type = map(object({
    location = string

    storage = map(object({
      replication = string
      tier        = string
    }))
  }))
}