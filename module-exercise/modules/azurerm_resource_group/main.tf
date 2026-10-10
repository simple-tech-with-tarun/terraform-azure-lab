resource "azurerm_resource_group" "rg" {
  for_each   = var.rg_m
  name       = each.value.name
  location   = each.value.location
  managed_by = each.value.managed_by
  tags = merge(
    each.value.tags,
    {
      owner = each.value.owner
    }
  )
}