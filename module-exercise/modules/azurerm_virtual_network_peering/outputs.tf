output "virtual_network_peering_name" {
  value = {
    for key, peer in azurerm_virtual_network_peering.vnet_peer :
    key => peer.name
  }
}

output "virtual_network_peering_id" {
  value = {
    for key, peer in azurerm_virtual_network_peering.vnet_peer :
    key => peer.id
  }
}

output "virtual_network_peering_settings" {
  value = {
    for key, peer in azurerm_virtual_network_peering.vnet_peer :
    key => {
      allow_virtual_network_access = peer.allow_virtual_network_access
      allow_forwarded_traffic      = peer.allow_forwarded_traffic
      allow_gateway_transit        = peer.allow_gateway_transit
      use_remote_gateways          = peer.use_remote_gateways
    }
  }
}
