output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.lab.name
}

output "location" {
  description = "Location of the Azure resource group."
  value       = azurerm_resource_group.lab.location
}
