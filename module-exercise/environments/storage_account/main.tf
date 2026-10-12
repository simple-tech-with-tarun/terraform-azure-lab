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

module "azure_storage_account" {
  source = "../../modules/azurerm_storage_account"
  sa_m = {
    for key, value in var.sa :
    key => {
      name                     = value.name
      resource_group_name      = module.azurerm_resource_group.resource_group_names[value.resource_group_key]
      location                 = value.location
      account_tier             = value.account_tier
      account_replication_type = value.account_replication_type

      public_network_access_enabled = value.public_network_access_enabled
      network_rules = {
        default_action = value.network_rules.default_action
        ip_rules       = value.network_rules.ip_rules
        subnet_ids = [
          module.azurerm_subnet.subnet_ids[value.subnet_key]
        ]
      }

      https_traffic_only_enabled      = value.https_traffic_only_enabled
      min_tls_version                 = value.min_tls_version
      allow_nested_items_to_be_public = value.allow_nested_items_to_be_public
      shared_access_key_enabled       = value.shared_access_key_enabled

      blob_soft_delete_days      = value.blob_soft_delete_days
      container_soft_delete_days = value.container_soft_delete_days
      blob_versioning_enabled    = value.blob_versioning_enabled
      change_feed_enabled        = value.change_feed_enabled

      tags  = value.tags
      owner = value.owner

    }
  }
}
