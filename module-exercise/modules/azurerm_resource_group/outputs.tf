output "resource_group_names" {
  description = "Names of the Resource Gruop created"
  value = {
    for key, rg in azurerm_resource_group.rg :
    key => rg.name
  }
}
