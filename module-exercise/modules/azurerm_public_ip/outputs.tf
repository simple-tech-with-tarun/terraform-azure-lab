output "public_ip_ids" {
  value = {
    for ip, value in azurerm_public_ip.public_ip :
    ip => value.id
  }
}

output "public_ip_names" {
  value = {
    for ip, value in azurerm_public_ip.public_ip :
    ip => value.name
  }
}
output "public_ip_addresses" {
  value = {
    for ip, value in azurerm_public_ip.public_ip :
    ip => value.ip_address
  }
}

output "public_ip_fqdns" {
  value = {
    for ip, value in azurerm_public_ip.public_ip :
    ip => value.fqdn
  }
}
