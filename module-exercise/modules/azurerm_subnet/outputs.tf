output "subnet_ids" {
  description = "IDs of the created subnets."
  value = {
    for key, subnet in azurerm_subnet.subnet :
    key => subnet.id
  }
}

output "subnet_address_prefixes" {
  description = "Address Prefixes of the created subnets."
  value = {
    for key, subnet in azurerm_subnet.subnet :
    key => subnet.address_prefixes
  }
}
output "subnet_names" {
  value = {
    for key, value in azurerm_subnet.subnet :
    key => value.name
  }
}
