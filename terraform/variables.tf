variable "environment" {
  type = map(object({
    name     = string
    location = string
    owner    = string

    resource_group = string

    storage_accounts = map(object({
      name                     = string
      account_tier             = string
      account_replication_type = string
    }))
  }))
}

variable "environment_name" {

  description = "Name of the environment to deploy"
  type = string

  validation {
    condition = contains (
      ["dev", "test"] , var.environment_name
    )
    error_message = "environment_name must be one of: dev or test."
  }
}