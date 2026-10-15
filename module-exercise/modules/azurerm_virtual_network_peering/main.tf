resource "azurerm_virtual_network_peering" "vnet_peer" {
  for_each                  = var.vnet_peer_m
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name_1
  virtual_network_name      = each.value.virtual_network_name_1
  remote_virtual_network_id = data.azurerm_virtual_network.vnet[each.key].id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

data "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet_peer_m
  name                = each.value.virtual_network_name_2
  resource_group_name = each.value.resource_group_name_2
}