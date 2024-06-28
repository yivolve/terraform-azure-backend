terraform {
  required_version = ">= 1.5.5, < 1.6"

  required_providers {
    azurerm  = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}

provider "azurerm" {
    features {}
}
