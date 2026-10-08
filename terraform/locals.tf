locals {
  selected_config = var.config[var.environment_name]

  name_prefix = "${var.project_name}${var.environment_name}"

  group_name = "${local.name_prefix}-rg"

  storage_config = {
    for storage_name, storage_config in local.selected_config.storage :
    storage_name => {
      name        = "${local.name_prefix}${storage_name}"
      replication = storage_config.replication
      tier        = storage_config.tier
    }
  }

  common_tags = {
    Project         = var.project_name
    Environment     = var.environment_name
    EnvironmentType = local.environment_type
    Owner           = var.owner
    ManagedBy       = "Terraform"
  }
  environment_type = var.environment_name == "dev" ? "non-production" : "testing"
}
