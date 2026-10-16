variable "environment" {
  type = string
}

variable "purpose" {
  type = string
}

variable "owner" {
  type = string
  validation {
    condition     = length(trimspace(var.owner)) > 0
    error_message = "Owner tag in mandatory"
  }
}

variable "rg" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
  }))
}

variable "vnet" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number)
  }))

  validation {
    condition = alltrue([
      for key in values(var.vnet) :
      length(key.address_space) > 0
    ])
    error_message = "Each virtual network must have at least one address space"
  }
}

variable "subnet" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints = optional(list(object({
      service            = string
      network_identifier = optional(string)
    })), [])

    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, false)
    delegation = optional(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string), [])
    }))
  }))
}

variable "nsg" {
  description = "Details of the Network Security Group module"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      description                = optional(string)
    }))
  }))
}

variable "association" {
  description = "Map of subnet and network security group IDs to associate"
  type = map(object({
    subnet_name                 = string
    network_security_group_name = string
    virtual_network_name        = string
    resource_group_name         = string
  }))
}

variable "vnet_peer" {
  type = map(object({
    name                   = string
    resource_group_name_1  = string
    resource_group_name_2  = string
    virtual_network_name_1 = string
    virtual_network_name_2 = string

    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for peer in values(var.vnet_peer) :
      contains(local.rg_names, peer.resource_group_name_1) &&
      contains(local.rg_names, peer.resource_group_name_2) &&
      contains(local.vnet_names, peer.virtual_network_name_1) &&
      contains(local.vnet_names, peer.virtual_network_name_2)
    ])
    error_message = "Each peering must reference resource groups and virtual networks defined in the input configuration."
  }
}

variable "vm" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    size                = string
    admin_username      = string

    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    admin_password      = optional(string)
    authentication_type = string
    admin_ssh_key = optional(object({
      username   = string
      public_key = string
    }))
    nic_name = string

    ip_configuration = object({
      name                          = string
      subnet_name                   = string
      virtual_network_name          = string
      private_ip_address_allocation = string
      public_ip_address_name        = optional(string)
      public_ip_resource_group_name = optional(string)
      primary                       = optional(bool, true)
      private_ip_address            = optional(string)
    })
  }))

  validation {
    condition = alltrue([
      for key in values(var.vm) :
      contains(["Static", "Dynamic"], key.ip_configuration.private_ip_address_allocation)
    ])
    error_message = "Private IP allocation method must be either Static or Dynamic"
  }
  validation {
    condition = alltrue([
      for key in values(var.vm) :
      contains(["password", "ssh"], key.authentication_type)
    ])
    error_message = "Authentication method must be password or ssh"
  }

  validation {
    condition = alltrue([
      for key in values(var.vm) :
      (
        key.authentication_type == "ssh" &&
        key.admin_ssh_key != null &&
        length(trimspace(key.admin_ssh_key != null ? key.admin_ssh_key.public_key : "")) > 0 &&
        key.admin_password == null
      )
      ||
      (
        key.authentication_type == "password" &&
        key.admin_password != null &&
        length(trimspace(key.admin_password != null ? key.admin_password : "")) > 0 &&
        key.admin_ssh_key == null
      )
    ])
    error_message = "Set authentication_type to 'ssh' with a non-empty public key, or 'password' with a non-empty password. Do not provide both credentials."
  }

  validation {
    condition = alltrue([
      for key in values(var.vm) :
      (
        key.ip_configuration.private_ip_address_allocation == "Static" &&
        key.ip_configuration.private_ip_address != null &&
        length(trimspace(key.ip_configuration.private_ip_address != null ? key.ip_configuration.private_ip_address : "")) > 0
      )
      ||
      (
        key.ip_configuration.private_ip_address_allocation == "Dynamic" &&
        key.ip_configuration.private_ip_address == null
      )

    ])
    error_message = "Static IP configurations must specify a non-empty private IP address. Dynamic IP configurations must not specify a private IP address."
  }
}
