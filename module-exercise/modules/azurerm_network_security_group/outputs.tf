output "network_security_group_ids" {
  description = "IDs of the Network Security Groups"
  value = {
    for key, value in azurerm_network_security_group.nsg :
    key => value.id
  }
}

output "network_security_group_names" {
  description = "Names of the Network Security Groups"
  value = {
    for key, value in azurerm_network_security_group.nsg :
    key => value.name
  }
}