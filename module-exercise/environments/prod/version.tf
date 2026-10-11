terraform {
  required_version = "> 1.4.0 , < 2.0.0"
  required_providers {
    azureem = {
      source  = "hashicorp/azurerm"
      version = ">= 4.9.0, < 5.0.0"
    }
  }
}
