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
```

1. Copy the snippet below on the `repo_name/project_name/aws_backend/terragrunt.hcl` file and **REPLACE** the local values accordanly:

  ```hcl
  terraform {
    source = "tfr:///yivolve/terraform-backend/azure?version=<tag version>"
  }

  locals {
    global_commons = yamldecode(file(find_in_parent_folders("global_commons.yaml")))
  }

  include "root" {
    path = find_in_parent_folders()
  }

  include "global_providers" {
    path = find_in_parent_folders("global_providers.hcl")
  }
  ```

1. Now, copy the snippet below on the on the `repo_name/project_name/terragrunt.hcl` and **REPLACE** the local values accordanly
    > Note: the "remote_state" block MUST be commented the first time the azure_backend project is deployed.

1. Go to `repo_name/project_name/aws_backend/` and run:

    ```bash
    terragrunt apply # Review and apply
    ```

1. Now, open the `repo_name/project_name/terragrunt.hcl` file and uncomment the `remote_state` block.

1. Now on the `repo_name/project_name/aws_backend/` directory run the command below to migrate the local backend to the remote azurerm backend:

    ```bash
    terragrunt init --reconfigure && terragrunt plan
    ```

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
