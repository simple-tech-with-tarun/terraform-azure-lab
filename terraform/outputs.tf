output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "network_details" {
  value = {
    name          = azurerm_virtual_network.lab.name
    id            = azurerm_virtual_network.lab.id
    address_space = azurerm_virtual_network.lab.address_space
  }
}

output "subnet_ids" {
  value = {
    for key, subnet in azurerm_subnet.lab :
    key => subnet.id
  }
}

output "storage_account_details" {
  value = {
    for key, account in azurerm_storage_account.lab :
    key =>
    {
      name             = account.name
      id               = account.id
      primary_location = account.primary_location
      replication_type = account.account_replication_type
      tags             = account.tags
    }
  }
}

output "subnet_names" {
  value = [for subnet in azurerm_subnet.lab : subnet.name]
}

output "environment_summary" {
  value = {
    project_name   = var.project_name
    environment    = var.environment
    location       = var.location
    resource_group = azurerm_resource_group.lab.name
    tags           = local.common_tags
    sa_tags = {
      for key, account in azurerm_storage_account.lab :
      key => account.tags
    }
  }
}
output "lab_demo_token" {
  description = "Dummy value for practising sensitive output handling"
  value       = "demo-token-not-a-real-secret"
  sensitive   = true
}
