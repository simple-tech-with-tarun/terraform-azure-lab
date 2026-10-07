terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lab" {
  name     = var.environment[var.environment_name].resource_group
  location = var.environment[var.environment_name].location

  tags = {
    Environment = var.environment[var.environment_name].name
    Owner       = var.environment[var.environment_name].owner
    ManagedBy   = "Terraform"
    AutoDelete  = "Yes"
  }
}

resource "azurerm_storage_account" "lab" {
  for_each = var.environment[var.environment_name].storage_accounts

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}
