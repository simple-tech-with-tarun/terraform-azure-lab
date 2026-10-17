module "azurerm_resource_group" {
  source = "../module-exercise/modules/azurerm_resource_group"
  rg_m = {
    for key, value in var.rg :
    key => {
      name        = value.name
      location    = value.location
      mananged_by = value.managed_by
      owner       = local.owner
      tags        = local.common_tags
    }
  }
}

module "azurerm_virtual_network" {
  depends_on = [module.azurerm_resource_group]
  source     = "../module-exercise/modules/azurerm_virtual_network"
  vnet_m = {
    for key, value in var.vnet :
    key => {
      name                    = value.name
      resource_group_name     = value.resource_group_name
      location                = value.location
      address_space           = value.address_space
      dns_servers             = value.dns_servers
      flow_timeout_in_minutes = value.flow_timeout_in_minutes

      owner = local.owner
      tags  = local.common_tags
    }
  }
}

module "azurerm_subnet" {
  depends_on = [module.azurerm_virtual_network]
  source     = "../module-exercise/modules/azurerm_subnet"
  subnet_m   = var.subnet
}

module "azurerm_network_security_group" {
  depends_on = [module.azurerm_subnet]
  source     = "../module-exercise/modules/azurerm_network_security_group"
  nsg_m = {
    for key, value in var.nsg :
    key => {
      name                = value.name
      location            = value.location
      resource_group_name = value.resource_group_name

      owner = local.owner
      tags  = local.common_tags

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

module "azurerm_subnet_nsg_association" {
  depends_on = [
    module.azurerm_network_security_group,
    module.azurerm_subnet
  ]
  source        = "../module-exercise/modules/azurerm_subnet_nsg_association"
  association_m = var.association
}

module "azurerm_virtual_network_peering" {
  depends_on  = [module.azurerm_virtual_network]
  source      = "../module-exercise/modules/azurerm_virtual_network_peering"
  vnet_peer_m = var.vnet_peer
}


module "azurerm_linux_virtual_machine" {
  depends_on = [
    module.azurerm_subnet,
    module.azurerm_network_security_group

  ]
  source = "../module-exercise/modules/azurerm_linux_virtual_machine"
  vm_m   = var.vm
}

module "azurerm_public_ip" {
  depends_on = [module.azurerm_resource_group]
  source     = "../module-exercise/modules/azurerm_public_ip"
  public_ip_m = {
    for key, value in var.public_ip :
    key => {
      name                = value.name
      resource_group_name = value.resource_group_name
      location            = value.location

      allocation_method       = value.allocation_method
      sku                     = value.sku
      sku_tier                = value.sku_tier
      ip_version              = value.ip_version
      zones                   = value.zones
      domain_name_label       = value.domain_name_label
      domain_name_label_scope = value.domain_name_label_scope
      reverse_fqdn            = value.reverse_fqdn
      idle_timeout_in_minutes = value.idle_timeout_in_minutes
      public_ip_prefix_id     = value.public_ip_prefix_id
      ip_tags                 = value.ip_tags
      ddos_protection_mode    = value.ddos_protection_mode
      ddos_protection_plan_id = value.ddos_protection_plan_id
      edge_zone               = value.edge_zone

      owner = local.owner
      tags  = local.common_tags
    }
  }
}
