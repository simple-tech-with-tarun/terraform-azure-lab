resource "azurerm_storage_account" "sa" {
  for_each            = var.sa_m
  name                = each.value.name
  resource_group_name = each.value.resource_group_name

  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  public_network_access_enabled = each.value.public_network_access_enabled


  network_rules {
    default_action             = each.value.network_rules.default_action
    ip_rules                   = each.value.network_rules.ip_rules
    virtual_network_subnet_ids = each.value.network_rules.subnet_ids
  }

  https_traffic_only_enabled      = each.value.https_traffic_only_enabled
  min_tls_version                 = each.value.min_tls_version
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
  shared_access_key_enabled       = each.value.shared_access_key_enabled

  blob_properties {
    delete_retention_policy {
      days = each.value.blob_soft_delete_days
    }
    container_delete_retention_policy {
      days = each.value.container_soft_delete_days
    }

    versioning_enabled  = each.value.blob_versioning_enabled
    change_feed_enabled = each.value.change_feed_enabled
  }

  tags = merge(
    each.value.tags,
    {
      owner = each.value.owner
  })
}
