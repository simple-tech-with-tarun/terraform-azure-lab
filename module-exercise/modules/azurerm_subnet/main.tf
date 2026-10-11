resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_m
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  service_endpoints = each.value.service_endpoints

  private_endpoint_network_policies = each.value.private_endpoint_network_policies
  default_outbound_access_enabled   = each.value.default_outbound_access_enabled

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.service_delegation_actions
      }
    }
  }
}
