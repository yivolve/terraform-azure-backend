output "resource_group_name" {
  value = module.terraform-azure-backend.resource_group_name
}

output "storage_account_name" {
  value = module.terraform-azure-backend.storage_account_name
}

output "container_name" {
  value = module.terraform-azure-backend.container_name
}
