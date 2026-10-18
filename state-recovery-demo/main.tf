resource "azurerm_resource_group" "recovery" {
  for_each = var.resource_groups

  name       = each.value.name
  location   = each.value.location
  managed_by = "Terraform"

  tags = {
    Purpose = "terraform-state-recovery-demo"
    Owner   = "Tarun"
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      tags["AutoDelete"]
    ]
  }
}

resource "azurerm_virtual_network" "recovery" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = azurerm_resource_group.recovery[each.value.resource_group_key].location
  resource_group_name = azurerm_resource_group.recovery[each.value.resource_group_key].name
  address_space       = each.value.address_space
}

resource "azurerm_subnet" "recovery" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.recovery[each.value.vnet_key].resource_group_name
  virtual_network_name = azurerm_virtual_network.recovery[each.value.vnet_key].name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "recovery" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = azurerm_resource_group.recovery[each.value.resource_group_key].location
  resource_group_name = azurerm_resource_group.recovery[each.value.resource_group_key].name
}

resource "azurerm_network_security_rule" "inbound" {
  for_each = var.network_security_groups

  name                        = each.value.inbound_rule_name
  priority                    = each.value.inbound_priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = tostring(each.value.inbound_port)
  source_address_prefix       = var.trusted_source_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.recovery[each.value.resource_group_key].name
  network_security_group_name = azurerm_network_security_group.recovery[each.key].name
}

resource "azurerm_network_security_rule" "outbound_https" {
  for_each = var.network_security_groups

  name                        = "AllowOutboundHTTPS"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.recovery[each.value.resource_group_key].name
  network_security_group_name = azurerm_network_security_group.recovery[each.key].name
}

resource "azurerm_subnet_network_security_group_association" "recovery" {
  for_each = var.network_security_groups

  subnet_id                 = azurerm_subnet.recovery[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.recovery[each.key].id
}
