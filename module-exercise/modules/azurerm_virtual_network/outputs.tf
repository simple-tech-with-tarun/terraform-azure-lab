output "virtual_network_ids" {
  description = "IDs of the created virtual networks."
  value = {
    for key, vnet in azurerm_virtual_network.vnet :
    key => vnet.id
  }
}

output "virtual_network_names" {
  description = "Names of the created virtual networks."
  value = {
    for key, vnet in azurerm_virtual_network.vnet :
    key => vnet.name
  }
}
output "virtual_network_address_spaces" {
  description = "Address spaces of the created virtual networks."
  value = {
    for key, vnet in azurerm_virtual_network.vnet :
    key => vnet.address_space
  }
}
output "virtual_network_dns_servers" {
  description = "DNS servers configured for each virtual network."
  value = {
    for key, vnet in azurerm_virtual_network.vnet :
    key => vnet.dns_servers
  }
}
