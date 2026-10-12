variable "rg" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    owner      = string
    tags       = optional(map(string), {})
  }))
}

variable "vnet" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)

    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number)

    owner = string
    tags  = optional(map(string), {})
  }))
  validation {
    condition = alltrue([
      for vnet in values(var.vnet) :
      length(vnet.address_space) > 0 &&
      contains(keys(var.rg), vnet.resource_group_key)
    ])

    error_message = "Each virtual network must have at least one address space and reference an existing resource group key."
  }

}

variable "subnet" {
  type = map(object({
    name                = string
    virtual_network_key = string
    address_prefixes    = list(string)
    service_endpoints   = optional(list(string), [])

    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, false)
    delegation = optional(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string), [])
    }))
  }))
  validation {
    condition = alltrue([
      for subnet in values(var.subnet) :
      length(subnet.address_prefixes) > 0 &&
      contains(keys(var.vnet), subnet.virtual_network_key)
    ])

    error_message = "Each subnet must have at least one address space and reference an existing resource group key."
  }
}
variable "sa" {
  type = map(object({
    name                     = string
    resource_group_key       = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    subnet_key               = string

    # Network access
    public_network_access_enabled = optional(bool, false)

    network_rules = optional(object({
      default_action = optional(string, "Deny")
      ip_rules       = optional(list(string), [])
    }), {})

    # Security
    https_traffic_only_enabled      = optional(bool, true)
    min_tls_version                 = optional(string, "TLS1_2")
    allow_nested_items_to_be_public = optional(bool, false)
    shared_access_key_enabled       = optional(bool, true)

    # Blob data protection
    blob_soft_delete_days      = optional(number, 14)
    container_soft_delete_days = optional(number, 14)
    blob_versioning_enabled    = optional(bool, true)
    change_feed_enabled        = optional(bool, false)

    tags  = optional(map(string), {})
    owner = string
  }))

  validation {
    condition = alltrue([
      for sa in values(var.sa) :
      contains(keys(var.rg), sa.resource_group_key) &&
      contains(keys(var.subnet), sa.subnet_key) &&
      contains(["Standard", "Premium"], sa.account_tier) &&
      contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], sa.account_replication_type) &&
      contains(["Allow", "Deny"], sa.network_rules.default_action)
    ])

    error_message = "Each Storage Account must reference an existing Resource Group and subnet, and use supported tier, replication, and network-rule values."
  }
}
