locals {
  custom_tags = merge(
    { scope = "Terraform" },
  var.tags)
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "iac_backend" {
  name     = random_pet.rg_name.id
  location = var.backend_location
  tags     = local.custom_tags
}

resource "azurerm_storage_account" "storage_account_for_iac_backend" {
  name                     = var.backend_storage_account_name
  resource_group_name      = azurerm_resource_group.iac_backend.name
  location                 = azurerm_resource_group.iac_backend.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = local.custom_tags
}

resource "azurerm_storage_container" "storage_container_iac_backend" {
  name                  = var.backend_storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account_for_iac_backend.name
  container_access_type = var.container_access_type
}
