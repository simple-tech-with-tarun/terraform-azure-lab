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

resource "azurerm_resource_group" "drift_demo" {
  name     = "tf-azure-dependency-demo-rg2"
  location = "eastus"
  tags = {
    Owner      = "Azure"
    AutoDelete = "Yes"

  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      tags["Owner"]
    ]
  }
}

resource "azurerm_storage_account" "drift_demo" {
  name                     = "tfazdependency2026"
  resource_group_name      = azurerm_resource_group.drift_demo.name
  location                 = azurerm_resource_group.drift_demo.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
resource "azurerm_storage_container" "deletable" {
  for_each = var.deletable_containers

  name                  = each.value
  storage_account_id    = azurerm_storage_account.drift_demo.id
  container_access_type = "private"
}

