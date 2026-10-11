variable "association_m" {
  description = "Map of subnet and network security group IDs to associate"
  type = map(object({
    subnet_name                 = string
    network_security_group_name = string
    virtual_network_name        = string
    resource_group_name         = string
  }))
}
