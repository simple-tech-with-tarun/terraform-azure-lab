variable "environment" {
  type = string
}

variable "purpose" {
  type = string
}

variable "owner" {
  type = string
  validation {
    condition     = length(trimspace(var.owner)) > 0
    error_message = "Owner tag in mandatory"
  }
}

variable "rg" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
  }))
}

variable "vnet" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number)
  }))

  validation {
    condition = alltrue([
      for key in values(var.vnet) :
      length(key.address_space) > 0
    ])
    error_message = "Each virtual network must have at least one address space"
  }
}

variable "subnet" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints = optional(list(object({
      service            = string
      network_identifier = optional(string)
    })), [])

    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, false)
    delegation = optional(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string), [])
    }))
  }))
}

variable "nsg" {
  description = "Details of the Network Security Group module"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      description                = optional(string)
    }))
  }))
}

variable "association" {
  description = "Map of subnet and network security group IDs to associate"
  type = map(object({
    subnet_name                 = string
    network_security_group_name = string
    virtual_network_name        = string
    resource_group_name         = string
  }))
}
