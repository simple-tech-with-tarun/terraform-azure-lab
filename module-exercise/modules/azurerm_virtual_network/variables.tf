variable "vnet_m" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number)

    owner = string
    tags  = optional(map(string), {})
  }))
  validation {
    condition = alltrue([
      for vnet in values(var.vnet_m) :
      length(vnet.address_space) > 0
    ])
    error_message = "Each virtual network must have at least one address space."
  }

}
