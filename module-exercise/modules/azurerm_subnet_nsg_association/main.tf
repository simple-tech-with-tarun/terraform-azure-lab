resource "azurerm_subnet_network_security_group_association" "association" {
   for_each                  = var.association_m
  subnet_id                 = data.azurerm_subnet.subnet[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
}
data "azurerm_subnet" "subnet" {
  for_each             = var.association_m
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

data "azurerm_network_security_group" "nsg" {
  for_each            = var.association_m
  name                = each.value.network_security_group_name
  resource_group_name = each.value.resource_group_name
}
