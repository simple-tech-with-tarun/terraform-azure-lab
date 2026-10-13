variable "sa_m" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string

    # Network access
    public_network_access = optional(string, "Disabled")

    network_rules = optional(object({
      default_action = optional(string, "Deny")
      ip_rules       = optional(list(string), [])
      subnet_ids     = optional(list(string), [])
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
      for key in values(var.sa_m) :

      contains(["Standard", "Premium"], key.account_tier) &&
      contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], key.account_replication_type) &&
      length(key.name) >= 3 &&
      length(key.name) <= 24 &&
      can(regex("^[a-z0-9]+$", key.name))

    ])
    error_message = "Storage Account names (3 to 24 characters, lowercase letters and numbers only) amd account tier must be either Standard or Premium and account replication type must be one of the following LRS, GRS, RAGRS, ZRS, GZRS, and RAGZRS"
  }

  validation {
    condition = alltrue([

      for key in values(var.sa_m) :
      contains(["TLS1_2"], key.min_tls_version)
    ])
    error_message = "Each Storage Account must use min_tls_version = \"TLS1_2\"."
  }

  validation {
    condition = alltrue([
      for key in values(var.sa_m) :

      key.blob_soft_delete_days <= 365 &&
      key.blob_soft_delete_days >= 1 &&
      key.blob_soft_delete_days == floor(key.blob_soft_delete_days) &&
      key.container_soft_delete_days <= 365 &&
      key.container_soft_delete_days >= 1 &&
      key.container_soft_delete_days == floor(key.container_soft_delete_days)

    ])
    error_message = "Blob soft-delete retention and container soft-delete retention must be a whole number between 1 and 365 days."
  }

  validation {
    condition = alltrue([
      for key in values(var.sa_m) :

      contains(["Allow", "Deny"], key.network_rules.default_action) &&

      alltrue([
        for subnet_id in key.network_rules.subnet_ids :
        length(trimspace(subnet_id)) > 0
      ]) &&

      alltrue([
        for ip in key.network_rules.ip_rules :
        can(cidrhost(
          strcontains(ip, "/") ? ip : "${ip}/32",
          0
        ))
      ])
    ])
    error_message = "Network rules must use Allow or Deny, non-empty subnet IDs, and valid IPv4 addresses or CIDR ranges."
  }
  validation {
    condition = alltrue([
      for key in values(var.sa_m):
      contains(["Enabled","Disabled"], key.public_network_access)
    ])
    error_message = "public_network_access must be either Enabled or Disabled"
  }
}
