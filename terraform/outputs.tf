output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.lab.name
}

output "location" {
  description = "Location of the Azure resource group."
  value       = azurerm_resource_group.lab.location
}

output "storage_account_id" {
  description = "Id of the Azure storage account"
  value       = azurerm_storage_account.lab.id
}

output "storage_container_name" {
  description = "Name of the Azure storage container"
  value       = azurerm_storage_container.lab.name
}
