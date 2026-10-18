variable "location" {
  description = "Default Azure region for the lab."
  type        = string
  default     = "Central India"
}

variable "resource_groups" {
  description = "Resource groups to create."
  type = map(object({
    name     = string
    location = string
  }))
}

variable "virtual_networks" {
  description = "Virtual networks keyed by logical name."
  type = map(object({
    name               = string
    resource_group_key = string
    address_space      = list(string)
  }))
}

variable "subnets" {
  description = "Subnets keyed by logical name."
  type = map(object({
    name             = string
    vnet_key         = string
    address_prefixes = list(string)
  }))
}