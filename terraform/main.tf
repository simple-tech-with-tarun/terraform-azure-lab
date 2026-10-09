resource "azurerm_resource_group" "lab" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      tags["AutoDelete"]
    ]
  }
}

resource "azurerm_virtual_network" "lab" {
  name                = "${local.name_prefix}-vnet"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

resource "azurerm_subnet" "lab" {
  for_each = {
    app  = "10.0.1.0/24"
    data = "10.0.2.0/24"
  }

  name                 = "${local.name_prefix}-${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [each.value]
}

resource "azurerm_storage_account" "lab" {
  for_each = {
    logs    = "LRS"
    backups = "GRS"
  }

  name                            = "${var.project_name}${var.environment}${each.key}"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  account_tier                    = "Standard"
  account_replication_type        = each.value
  allow_nested_items_to_be_public = false

  tags = merge(local.common_tags, {
    Purpose = each.key
  })
}
