variable "vm_m" {
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
      for key in values(var.vm_m) :
      contains(["Static", "Dynamic"], key.ip_configuration.private_ip_address_allocation)
    ])
    error_message = "Private IP allocation method must be either Static or Dynamic"
  }
  validation {
    condition = alltrue([
      for key in values(var.vm_m) :
      contains(["password", "ssh"], key.authentication_type)
    ])
    error_message = "Authentication method must be password or ssh"
  }

  validation {
    condition = alltrue([
      for key in values(var.vm_m) :
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
      for key in values(var.vm_m) :
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
