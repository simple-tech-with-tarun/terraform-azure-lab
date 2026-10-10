module "azurerm_resource_group" {
  source = "../../modules/azurerm_resource_group"
  rg_m   = var.rg
}

module "azurerm_virtual_network" {
  source = "../../modules/azurerm_virtual_network"
  vnet_m = {
    for key, value in var.vnet :
    key => {
      name                = value.name
      location            = value.location
      resource_group_name = module.azurerm_resource_group.resource_group_names[value.resource_group_key]
      address_space       = value.address_space

      dns_servers             = value.dns_servers
      flow_timeout_in_minutes = value.flow_timeout_in_minutes

      owner = value.owner
      tags  = value.tags
    }
  }
}
