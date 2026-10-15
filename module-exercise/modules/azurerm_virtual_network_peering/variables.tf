variable "vnet_peer_m" {
  type = map(object({
    name                   = string
    resource_group_name_1  = string
    resource_group_name_2  = string
    virtual_network_name_1 = string
    virtual_network_name_2 = string

    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
}