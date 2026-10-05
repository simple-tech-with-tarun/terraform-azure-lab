# output "resource_group_name" {
#   description = "Name of the Azure resource group."
#   value       = azurerm_resource_group.lab.name
# }

# output "location" {
#   description = "Location of the Azure resource group."
#   value       = azurerm_resource_group.lab.location
# }

# output "storage_account_id" {
#   description = "Id of the Azure storage account"
#   value       = azurerm_storage_account.lab.id
# }

# output "storage_container_name" {
#   description = "Name of the Azure storage container"
#   value       = azurerm_storage_container.lab.name
# }

# output "public_ip" {
#   description = "Pubic IP allocated to the Linux VM"
#   value       = azurerm_public_ip.vm.ip_address
# }
# output "private_ip" {
#   description = "Private IP allocated to the Linux VM"
#   value       = azurerm_network_interface.vm.private_ip_address
# }

# output "vm_principal_id" {
#   description = "Principal ID of the VM's system-assigned managed identity."
#   value       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
# }

# output "vm_storage_contributor" {
#   description = "Details of the role assignment of the VM"
#   value       = azurerm_role_assignment.vm_storage_contributor.role_definition_name
# }
output "existing_resource_group_name" {
  description = "Name of the existing admin resource group."
  value       = data.azurerm_resource_group.existing.name
}

output "existing_resource_group_location" {
  description = "Location of the existing admin resource group."
  value       = data.azurerm_resource_group.existing.location
}

output "existing_resource_group_ID" {
  description = "ID of the existing admin resource group."
  value       = data.azurerm_resource_group.existing.id
}
output "Storage_account_name" {
  value = azurerm_storage_account.data_source_demo.name
}

output "Storage_account_location" {
  value = azurerm_storage_account.data_source_demo.location
}
