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

module "azurerm_subnet" {
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

module "azurerm_network_security_group" {
  source = "../../modules/azurerm_network_security_group"
  nsg_m = {
    for key, value in var.nsg :
    key => {
      name                = value.name
      resource_group_name = module.azurerm_resource_group.resource_group_names[value.resource_group_key]
      location            = value.location
      tags                = value.tags
      owner               = value.owner

      security_rules = {
        for rule_key, rule_value in value.security_rules :
        rule_key => {
          name                       = rule_value.name
          priority                   = rule_value.priority
          direction                  = rule_value.direction
          access                     = rule_value.access
          protocol                   = rule_value.protocol
          source_port_range          = rule_value.source_port_range
          destination_port_range     = rule_value.destination_port_range
          source_address_prefix      = rule_value.source_address_prefix
          destination_address_prefix = rule_value.destination_address_prefix
          description                = rule_value.description
        }
      }
    }
  }
}


module "azurerm_subnet_network_security_group_association" {
  depends_on = [module.azurerm_network_security_group, module.azurerm_subnet]
  source     = "../../modules/azurerm_subnet_nsg_association"
  association_m = {
    for key, value in var.association :
    key => {
      subnet_name                 = module.azurerm_subnet.subnet_names[value.subnet_key]
      network_security_group_name = module.azurerm_network_security_group.network_security_group_names[value.network_security_group_key]
      virtual_network_name        = module.azurerm_virtual_network.virtual_network_names[value.virtual_network_key]
      resource_group_name         = module.azurerm_resource_group.resource_group_names[value.resource_group_key]
    }
  }
}
