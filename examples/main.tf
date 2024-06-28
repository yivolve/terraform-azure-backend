locals {
  name = "${var.name}-${var.backend_location}"
}
module "terraform-azure-backend" {
  source = "../"

  resource_group_name_prefix     = local.name
  backend_location               = var.backend_location
  backend_storage_account_name   = replace(local.name, "-", "")
  backend_storage_container_name = local.name
}
