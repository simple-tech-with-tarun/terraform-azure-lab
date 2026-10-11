variable "nsg_m" {
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
    owner = string
    tags  = optional(map(string), {})
  }))
}
