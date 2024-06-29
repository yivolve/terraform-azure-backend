# terraform-azure-terraform-backend

Terraform module to create a terraform backend to be used on Azure.

## Table of Contents

- [Deploy Azure backend Using Terragrunt](#deploy-azure-backend-using-terragrunt)
- [Remove Azure Backend Using Terragrunt](#remove-azure-backend-using-terragrunt)

### Deploy Azure Backend Using Terragrunt

For deploy the module containing the aws backend using terraform we'll assume the following directory structure is used:

```bash
repo_name
  - project_name
    - azure_backend
      - terragrunt.hcl
    - terragrunt.hcl
    - global_commons.yaml
```

1. Copy the snippet below on the `repo_name/project_name/aws_backend/terragrunt.hcl` file and **REPLACE** the local values accordanly:

  ```hcl
  terraform {
    source = "tfr:///yivolve/terraform-backend/azure?version=0.0.5"
  }

  locals {
    commons                    = yamldecode(file("${get_parent_terragrunt_dir()}/global_commons.yaml"))
    terraform_required_version = local.commons.terraform_required_version
    azurerm_provider_version   = local.commons.azurerm_provider_version
  }

  include "root" {
    path = find_in_parent_folders()
  }

  // Global Provider
  generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
  terraform {
    required_version = "${local.terraform_required_version}"
    required_providers {
      azurerm  = {
        source  = "hashicorp/azurerm"
        version = "${local.azurerm_provider_version}"
      }
    }
  }

  provider "azurerm" {
    features {}
  }

  EOF
  }


  inputs = {} // No inputs needed as these are inherented from the root terragrunt.hcl file
  ```

1. Now, copy the snippet below on the on the `repo_name/project_name/global_commons.yaml` and **REPLACE** the values accordanly:

```yaml
## Gobal values
azure_subscription_id: "123-456-789-654"
global_project_id: name_id

## Provider Global Values
azure_region: <region>
terraform_required_version: ">= 1.5.6, < 1.6.0"
azurerm_provider_version: "~> 3.110"


## Terraform Azure Backend Values
Backend:
  resource_group_name: REPLACE_ME
  backend_location: <region>
  backend_name: some-name-region> # The specified region must be as the on the backend_location field value.

```

1. Now, copy the snippet below on the on the `repo_name/project_name/terragrunt.hcl` and **REPLACE** the local values accordanly:

  > Note: the "remote_state" block MUST be commented the first time the azure_backend project is deployed.

  ```hcl
  locals {
    global_commons = yamldecode(file("${get_parent_terragrunt_dir()}/global_commons.yaml"))

    azure_subscription_id          = local.global_commons.azure_subscription_id
    backend_location               = local.global_commons.Backend.backend_location
    backend_common_name            = "${local.global_commons.global_project_id}-${local.global_commons.Backend.backend_name}"
    backend_storage_account_name   = replace(local.backend_common_name, "-", "")
    backend_storage_container_name = local.backend_common_name
    custom_tags = { Add here some global tags you might need on your project  }
  }

  generate "versions" {
    path      = "versions.tf"
    if_exists = "overwrite"
    contents  = <<EOF
  EOF
  }

  remote_state {
    backend = "azurerm"
    generate = {
      path      = "backend.tf"
      if_exists = "overwrite_terragrunt"
    }
    config = {
      subscription_id      = local.azure_subscription_id
      resource_group_name  = local.global_commons.Backend.resource_group_name
      storage_account_name = local.backend_storage_account_name
      container_name       = local.backend_storage_container_name
      key                  = "${path_relative_to_include("site")}/terraform.tfstate"
    }
  }

  inputs = merge(
    {
      backend_location               = local.backend_location
      backend_storage_account_name   = local.backend_storage_account_name
      backend_storage_container_name = local.backend_storage_container_name
      custom_tags                    = local.custom_tags
      tags                           = local.custom_tags
    }
  )
  ```

1. Go to `repo_name/project_name/aws_backend/` and run:

    ```bash
    terragrunt apply # Review and apply
    ```

1. Get the `resource_group_name` and add it to the `Backend.resource_group_name` field on the `repo_name/project_name/global_commons.yaml` file.

1. Now, open the `repo_name/project_name/terragrunt.hcl` file and uncomment the `remote_state` block.

1. Now on the `repo_name/project_name/aws_backend/` directory run the command below to migrate the local backend to the remote azurerm backend:

    ```bash
    terragrunt init --reconfigure && terragrunt plan
    ```

    This will show the following message or similar:

    ```bash
    Initializing the backend...
    Acquiring state lock. This may take a few moments...
    Do you want to copy existing state to the new backend?
      Pre-existing state was found while migrating the previous "local" backend to the
      newly configured "azurerm" backend. No existing state was found in the newly
      configured "azurerm" backend. Do you want to copy this state to the new "azurerm"
      backend? Enter "yes" to copy and "no" to start with an empty state.

      Enter a value:
    ```

   Now type yes and hit enter.

1. Commit and push your changes

### Remove Azure Backend Using Terragrunt

If you ever need to delete the azurerm services then follow the steps bellow:

1. Run the commands below to ensure terraform knows about the backend configuration (which is on the `.terraform.terraform.tfstate` file):

    ```bash
    rm -rf $TERRAGRUNT_DOWNLOAD/* && terragrunt init --reconfigure
    ```

1. Open the root `terragrunt.hcl` file containing the backend configuration and comment out the `remote_state` block.
1. Run `terragrunt init -migrate-state` this will copy the state file from the remote azurerm blob container to the local disk, a message will apear explaining this:

    ```bash
    Initializing the backend...
    Terraform has detected you're unconfiguring your previously set "azurerm" backend.
    Acquiring state lock. This may take a few moments...
    Do you want to copy existing state to the new backend?
      Pre-existing state was found while migrating the previous "azurerm" backend to the
      newly configured "local" backend. No existing state was found in the newly
      configured "local" backend. Do you want to copy this state to the new "local"
      backend? Enter "yes" to copy and "no" to start with an empty state.

      Enter a value:
    ```

1. type `yes`
1. Optional - Go to the Azure console and empty the azurerm.
1. Run `terragrunt destroy` to destroy the backend resources.
