resource "azurerm_resource_group" "lab" {
  name     = local.group_name
  location = local.selected_config.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "lab" {
  depends_on               = [azurerm_resource_group.lab]
  for_each                 = local.storage_config
  name                     = each.value.name
  location                 = local.selected_config.location
  resource_group_name      = local.group_name
  account_tier             = each.value.tier
  account_replication_type = each.value.replication
}
