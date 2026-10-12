output "storage_account_ids" {
  description = "IDs of the Storage Accounts created by this module."
  value = {
    for key, sa in azurerm_storage_account.sa :
    key => sa.id
  }
}

output "storage_account_names" {
  description = "Names of the Storage Accounts created by this module."
  value = {
    for key, sa in azurerm_storage_account.sa :
    key => sa.name
  }
}

output "primary_blob_endpoints" {
  description = "Primary blob service endpoints of the Storage Accounts."
  value = {
    for key, sa in azurerm_storage_account.sa :
    key => sa.primary_blob_endpoint
  }
}
