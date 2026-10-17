resource "azurerm_public_ip" "public_ip" {
  for_each            = var.public_ip_m
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  allocation_method       = each.value.allocation_method
  sku                     = each.value.sku
  sku_tier                = each.value.sku_tier
  ip_version              = each.value.ip_version
  zones                   = each.value.zones
  domain_name_label       = each.value.domain_name_label
  domain_name_label_scope = each.value.domain_name_label_scope
  reverse_fqdn            = each.value.reverse_fqdn
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  public_ip_prefix_id     = each.value.public_ip_prefix_id
  ip_tags                 = each.value.ip_tags
  ddos_protection_mode    = each.value.ddos_protection_mode
  ddos_protection_plan_id = each.value.ddos_protection_plan_id
  edge_zone               = each.value.edge_zone

  tags = merge(
    each.value.tags,
    {
      owner = each.value.owner
    }
  )
}
