resource "azurerm_resource_group" "recovery" {
  for_each = var.resource_groups

  name       = each.value.name
  location   = each.value.location
  managed_by = "Terraform"
  tags = {
    Purpose = "terraform-state-recovery-demo"
    owner   = "Tarun"
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