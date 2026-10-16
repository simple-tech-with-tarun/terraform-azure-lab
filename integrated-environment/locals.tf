locals {
  common_tags = {
    environment = var.environment
    purpose     = var.purpose
  }
  owner      = var.owner
  rg_names   = [for rg in values(var.rg) : rg.name]
  vnet_names = [for vnet in values(var.vnet) : vnet.name]


  vm_public_ip = {
    for key, value in var.vm :
    key => value
    if value.ip_configuration.public_ip_address_name != null
  }
}