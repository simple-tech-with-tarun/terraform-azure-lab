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

variable "vnet_name" {
  description = "Name of the Azure Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Azure Virtual Network."
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet."
  type        = list(string)
}

variable "nsg_name" {
  description = "Name of the Network Security Group."
  type        = string
}
variable "vm_name" {
  description = "Name of the Linux virtual machine."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key used to access the Linux VM."
  type        = string
}

variable "admin_source_cidr" {
  description = "CIDR range allowed to access the VM over SSH."
  type        = string
}