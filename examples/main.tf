locals {
  name = "${var.name}-${var.location}"
}
module "terraform-azure-backend" {
  source                = "../"

  resource_group_name_prefix = local.name
  location = var.location
  storage_account_name = replace(local.name, "-", "")
  storage_container_name = local.name
}
