variable "rg" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    owner      = string
    tags       = optional(map(string), {})
  }))
}

variable "vnet" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)

    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number)

    owner = string
    tags  = optional(map(string), {})
  }))
  validation {
    condition = alltrue([
      for vnet in values(var.vnet) :
      length(vnet.address_space) > 0 &&
      contains(keys(var.rg), vnet.resource_group_key)
    ])

    error_message = "Each virtual network must have at least one address space and reference an existing resource group key."
  }

}

variable "subnet" {
  type = map(object({
    name                = string
    virtual_network_key = string
    address_prefixes    = list(string)
    service_endpoints   = optional(list(string), [])

    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, false)
    delegation = optional(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string), [])
    }))
  }))
  validation {
    condition = alltrue([
      for subnet in values(var.subnet) :
      length(subnet.address_prefixes) > 0 &&
      contains(keys(var.vnet), subnet.virtual_network_key)
    ])

    error_message = "Each subnet must have at least one address space and reference an existing resource group key."
  }
}
