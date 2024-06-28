output "resource_group_name" {
  value = azurerm_resource_group.iac_backend.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account_for_iac_backend.name
}

output "container_name" {
  value = azurerm_storage_container.storage_container_iac_backend.name
}

# output "primary_access_key" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.primary_access_key
#   sensitive = true
# }

# output "secondary_access_key" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.secondary_access_key
#   sensitive = true
# }

# output "primary_connection_string" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.primary_connection_string
#   sensitive = true
# }

# output "secondary_connection_string" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.secondary_connection_string
#   sensitive = true
# }

# output "primary_blob_connection_string" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.primary_blob_connection_string
#   sensitive = true
# }

# output "secondary_blob_connection_string" {
#   value     = azurerm_storage_account.storage_account_for_iac_backend.secondary_blob_connection_string
#   sensitive = true
# }
