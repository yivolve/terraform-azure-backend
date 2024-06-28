variable "location" {
  type     = string
  default = "eastus"
}

variable "name" {
  type     = string
  description = "The name to be assigned to storage_account_name and storage_container_name"
  default = "iac-backend"
}
