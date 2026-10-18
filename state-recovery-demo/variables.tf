variable "location" {
  description = "Default Azure region for the lab."
  type        = string
  default     = "Central India"
}

variable "trusted_source_cidr" {
  description = "Trusted CIDR allowed to access inbound NSG rules."
  type        = string
  default     = "10.0.0.0/8"
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

variable "network_security_groups" {
  description = "NSGs with one inbound demonstration rule each."
  type = map(object({
    name               = string
    resource_group_key = string
    subnet_key         = string
    inbound_rule_name  = string
    inbound_port       = number
    inbound_priority   = number
  }))
}