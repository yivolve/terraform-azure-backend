variable "resource_group_name" {
  type        = string
  description = "(Required string) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required string) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}


variable "storage_account_name" {
  type        = string
  description = "(Required string) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
}

variable "storage_account_tier" {
  type        = string
  description = "(Required string) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "(Required string) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  default     = "LRS"
}


variable "storage_container_name" {
  type        = string
  description = "(Required string) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created."
}

variable "container_access_type" {
  type    = string
  default = "blob"
}

variable "tags" {
  type        = map(string)
  description = "(Optional map of strings) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
  default     = {}
}
