locals {
  vm_public_ip = {
    for key, value in var.vm_m :
    key => value
    if value.ip_configuration.public_ip_address_name != null
  }
}
