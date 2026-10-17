variable "public_ip_m" {
  type = map(object({

    name                = string
    resource_group_name = string
    location            = string
    owner               = string

    allocation_method       = optional(string, "Static")
    sku                     = optional(string, "Standard")
    sku_tier                = optional(string, "Regional")
    ip_version              = optional(string, "IPv4")
    zones                   = optional(list(string))
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string)
    reverse_fqdn            = optional(string)
    idle_timeout_in_minutes = optional(number, 4)
    public_ip_prefix_id     = optional(string)
    ip_tags                 = optional(map(string), {})
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string)
    edge_zone               = optional(string)

    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
      item.allocation_method == "Static" &&
      item.sku == "Standard"
    ])
    error_message = "Each Public IP must use Static allocation with the Standard SKU."
  }

  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
    contains(["IPv4", "IPv6"], item.ip_version)])
    error_message = "The ip_version must be either IPv4 or IPv6."
  }
  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
    contains(["Regional", "Global"], item.sku_tier)])
    error_message = "The sku_tier must be either Regional or Global."
  }
  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
      item.idle_timeout_in_minutes >= 4 &&
      item.idle_timeout_in_minutes <= 30
    ])
    error_message = "The idle_timeout_in_minutes must be between 4 and 30, inclusive."
  }

  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
      item.domain_name_label == null ? true : (
        length(item.domain_name_label) <= 63 &&
        can(regex(
          "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", item.domain_name_label
        ))
      )
    ])
    error_message = "Each domain_name_label must be at most 63 characters, contain only letters, numbers, and hyphens, and start and end with a letter or number."
  }

  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
      item.domain_name_label_scope == null ? true : (
        item.domain_name_label != null &&
        contains([
          "NoReuse",
          "ResourceGroupReuse",
          "SubscriptionReuse",
          "TenantReuse"
          ],
          item.domain_name_label_scope
        )
      )
    ])
    error_message = "domain_name_label_scope must be a supported scope and can only be set when domain_name_label is specified."
  }
  validation {
    condition = alltrue([
      for item in values(var.public_ip_m) :
      item.reverse_fqdn == null ? true : (
        length(trimspace(item.reverse_fqdn)) > 0 &&
        can(regex(
          "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)+$"
          , item.reverse_fqdn)
        )
      )
    ])
    error_message = "reverse_fqdn must be a non-empty, dot-separated domain name when specified."
  }
}
