variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
}

variable "resource_group_location" {
  description = "Azure region where the resource group will be created."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique name of the Azure Storage Account."
  type        = string
}

variable "storage_container_name" {
  description = "Name of the Blob Storage container."
  type        = string
}