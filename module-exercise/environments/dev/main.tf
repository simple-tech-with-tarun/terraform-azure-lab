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

module "azurerm_sbnet" {
  source = "../../modules/azurerm_subnet"
  subnet_m = {
    for key, value in var.subnet :
    key => {
      name                 = value.name
      resource_group_name  = module.azurerm_resource_group.resource_group_names[var.vnet[value.virtual_network_key].resource_group_key]
      virtual_network_name = module.azurerm_virtual_network.virtual_network_names[value.virtual_network_key]
      address_prefixes     = value.address_prefixes

      service_endpoints                 = value.service_endpoints
      private_endpoint_network_policies = value.private_endpoint_network_policies
      default_outbound_access_enabled   = value.default_outbound_access_enabled

      delegation = value.delegation == null ? null : {
        name                       = value.delegation.name
        service_delegation_name    = value.delegation.service_delegation_name
        service_delegation_actions = value.delegation.service_delegation_actions
      }
    }
  }
}
