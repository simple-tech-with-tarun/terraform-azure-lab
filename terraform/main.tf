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
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    Owner       = "Tarun"
    AutoDelete  = "Yes"
    Environment = "Dev"
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
      # tags["Environment"]
      # location
    ]
  }
}

resource "azurerm_storage_account" "lab" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lab" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.lab.id
  container_access_type = "private"
}
