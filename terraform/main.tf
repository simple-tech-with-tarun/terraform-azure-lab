resource "azurerm_resource_group" "lab" {
  name     = local.resource_names.resource_group
  location = local.selected_config.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "lab" {
  for_each                 = local.storage_config
  name                     = local.resource_names.storage[each.key]
  location                 = local.selected_config.location
  resource_group_name      = local.resource_names.resource_group
  account_tier             = each.value.tier
  account_replication_type = each.value.replication
}
