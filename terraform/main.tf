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

resource "azurerm_resource_group" "dependency_demo" {
  name     = "tf-azure-dependency-demo-rg2"
  location = "eastus"
  tags = {
    Owner      = "Tarun"
    AutoDelete = "Yes"

  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}

resource "azurerm_storage_account" "dependency_demo" {
  name                     = "tfazdependency2026"
  resource_group_name      = azurerm_resource_group.dependency_demo.name
  location                 = azurerm_resource_group.dependency_demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "deletable" {
  for_each = var.deletable_containers

  name                  = each.value
  storage_account_id    = azurerm_storage_account.dependency_demo.id
  container_access_type = "private"
}

