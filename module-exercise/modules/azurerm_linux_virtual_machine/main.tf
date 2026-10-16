resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_m
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration.name
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation

    public_ip_address_id = contains(
      keys(
        data.azurerm_public_ip.public_ip
      ),
      each.key
    ) ? data.azurerm_public_ip.public_ip[each.key].id : null

    primary            = each.value.ip_configuration.primary
    private_ip_address = each.value.ip_configuration.private_ip_address
  }
}

data "azurerm_subnet" "subnet" {
  for_each = var.vm_m

  name                 = each.value.ip_configuration.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.ip_configuration.virtual_network_name
}

data "azurerm_public_ip" "public_ip" {
  for_each = local.vm_public_ip
  resource_group_name = coalesce(
    each.value.ip_configuration.public_ip_resource_group_name,
    each.value.resource_group_name
  )
  name = each.value.ip_configuration.public_ip_address_name

}

resource "azurerm_linux_virtual_machine" "l_vm" {
  for_each = var.vm_m

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  disable_password_authentication = each.value.authentication_type == "ssh"
  admin_password                  = each.value.admin_password

  dynamic "admin_ssh_key" {
    for_each = each.value.authentication_type == "ssh" ? [each.value.admin_ssh_key] : []

    content {
      username   = admin_ssh_key.value.username
      public_key = file(admin_ssh_key.value.public_key)
    }
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
}
