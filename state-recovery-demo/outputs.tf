output "resource_group_names" {
  description = "Resource group names keyed by logical key."

  value = {
    for key, rg in azurerm_resource_group.recovery :
    key => rg.name
  }
}

output "resource_group_ids" {
  description = "Resource group IDs keyed by logical key."

  value = {
    for key, rg in azurerm_resource_group.recovery :
    key => rg.id
  }
}

output "virtual_network_names" {
  description = "VNet names keyed by logical key."

  value = {
    for key, vnet in azurerm_virtual_network.recovery :
    key => vnet.name
  }
}

output "subnet_ids" {
  description = "Subnet IDs keyed by logical key."

  value = {
    for key, subnet in azurerm_subnet.recovery :
    key => subnet.id
  }
}

output "network_security_group_names" {
  description = "NSG names keyed by logical key."

  value = {
    for key, nsg in azurerm_network_security_group.recovery :
    key => nsg.name
  }
}

output "subnet_nsg_associations" {
  description = "Subnet-to-NSG association IDs keyed by NSG key."

  value = {
    for key, association in azurerm_subnet_network_security_group_association.recovery :
    key => association.id
  }
}