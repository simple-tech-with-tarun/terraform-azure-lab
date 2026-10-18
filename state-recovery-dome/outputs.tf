output "resource_group_names" {
  description = "Resource group names keyed by logical resource group key."

  value = {
    for key, rg in azurerm_resource_group.recovery :
    key => rg.name
  }
}

output "resource_group_ids" {
  description = "Resource group IDs keyed by logical resource group key."

  value = {
    for key, rg in azurerm_resource_group.recovery :
    key => rg.id
  }
}

output "virtual_network_names" {
  description = "Virtual network names keyed by logical VNet key."

  value = {
    for key, vnet in azurerm_virtual_network.recovery :
    key => vnet.name
  }
}

output "subnet_ids" {
  description = "Subnet IDs keyed by logical subnet key."

  value = {
    for key, subnet in azurerm_subnet.recovery :
    key => subnet.id
  }
}