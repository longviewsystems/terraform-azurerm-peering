# Overview
This repo is a common template that can be used to scaffold a Terraform based project. 

It incorporates:

- `Pre-commit hooks` to enforce code formatting and document generation.
- GitHub Actions to invoke a security lint `Checkov` and basic unit tests `Terratest` using CI triggers.
- GitHub Actions to convert markdown to PDF using the Pandoc latex container image. 
- Semantic versioning using the open source `semantic-release` package. More information on versioning can be found [here](https://github.com/longviewsystems/terraform-azurerm-common-template/wiki/Semantic-Versioning "here"). 

Note that this repo deploys an Azure DevOps self-hosted agent as an example, and the Terraform configuraton files are scaffolded at the root of the repo. The intent here is not to highlight the Terraform code, but rather focus on the structure in order to support the development cycle using a common integration pipeline.

The design philosophy of this consumable is that it is meant to be run by a pipeline, therefore there is a level of abstraction from the user for values which should be set in the answers file (either `tfvars` or export `TF_VAR` environment variables). Long View's preferred approach is to use `tfvars` to set values.

------------


# Limitations
`GITHUB_TOKEN` is automatically created and distributed by GitHub Actions. It does not have sufficient permission to operate on protected branches. If you are using the CI in an environment with branch protection policies, then it is necessary to do two things:

1. Use a custom token (`GH_TOKEN_SEMANTIC_RELEASE`) with the repo scope. It is available as an environment secret at the organization level.
2. Avoid persisting credentials as part of `actions/checkout@v2` during the repo checkout stage to the runner, by setting the parameter `persist-credentials: false`.

```yaml
tag_module:
    name: 'Automated Tagging and Versioning using semantic-release'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          persist-credentials: false
      - uses: actions/setup-node@v1 #Install Node 15 apt repo
        with:
          node-version: 15.x
      - name: Install node modules
        run: |
          npm install npx semantic-release
          npm install @semantic-release/git @semantic-release/changelog
      - name: 'Run semantic-release'
        run: npx semantic-release
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN_SEMANTIC_RELEASE }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

------------


# Usage
To trigger a CI build in Github Actions, submit a PR to the dev/feature branch.

To trigger terratest in the local environment:
```bash
$ cd test
$ make azdo-agent-test
```

To deploy to an Azure tenant:
```bash
$ make azdo-agent
```

To destroy the infra in the Azure tenant:
```bash
$ make destroy
```

To cleanup the TF configuration files in your local dev env:
```bash
$ make clean
```

------------

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.88.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.95.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ip"></a> [ip](#module\_ip) | ./modules/workstation_public_ip | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.pipeline_agents_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.kvap_opinionated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.agent_pw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.agent_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_network_interface.pipeline_agents_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_resource_group.pipeline_agents_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.pipeline_agents_stor_acct](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.pipeline_agents_blob_scripts_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.pipeline_agents_container_scripts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.pipeline_agents_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.vm_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.pipeline_agents_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.windowsvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.admin_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_kv_name"></a> [agent\_kv\_name](#input\_agent\_kv\_name) | Name of the Key Vault for the agent | `string` | n/a | yes |
| <a name="input_agent_kv_pass"></a> [agent\_kv\_pass](#input\_agent\_kv\_pass) | Password for the agent in the KV | `string` | n/a | yes |
| <a name="input_agent_kv_user"></a> [agent\_kv\_user](#input\_agent\_kv\_user) | User name for the agent in the KV | `string` | n/a | yes |
| <a name="input_agent_script_path"></a> [agent\_script\_path](#input\_agent\_script\_path) | Relative location for agent script | `string` | n/a | yes |
| <a name="input_allowed_subnet_ids"></a> [allowed\_subnet\_ids](#input\_allowed\_subnet\_ids) | List of subnet IDs that are allowed to access the KV | `list(string)` | `null` | no |
| <a name="input_devops_org_url"></a> [devops\_org\_url](#input\_devops\_org\_url) | Azure DevOps Org URL | `string` | `""` | no |
| <a name="input_devops_pat"></a> [devops\_pat](#input\_devops\_pat) | PAT token for Azure DevOps | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Location | `string` | n/a | yes |
| <a name="input_pipeline_agents_nic"></a> [pipeline\_agents\_nic](#input\_pipeline\_agents\_nic) | NIC for build agent | `string` | n/a | yes |
| <a name="input_pipeline_agents_rg"></a> [pipeline\_agents\_rg](#input\_pipeline\_agents\_rg) | Resource group for build agent | `string` | n/a | yes |
| <a name="input_pipeline_agents_stor_acct"></a> [pipeline\_agents\_stor\_acct](#input\_pipeline\_agents\_stor\_acct) | Storage account for build agent | `string` | n/a | yes |
| <a name="input_pipeline_agents_subnet"></a> [pipeline\_agents\_subnet](#input\_pipeline\_agents\_subnet) | Subnet for build agent | `string` | n/a | yes |
| <a name="input_pipeline_agents_vnet"></a> [pipeline\_agents\_vnet](#input\_pipeline\_agents\_vnet) | vNet for build agent | `string` | n/a | yes |
| <a name="input_purge_protection"></a> [purge\_protection](#input\_purge\_protection) | Determines if purge protection is enabled or not for the KV | `string` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource Tags - read in from environment variables if not defined | `map(string)` | <pre>{<br>  "environment": "test",<br>  "managedBy": "terraform"<br>}</pre> | no |
| <a name="input_windows_agent_name"></a> [windows\_agent\_name](#input\_windows\_agent\_name) | Name of the Windows Agent | `string` | n/a | yes |
| <a name="input_windows_agent_pool"></a> [windows\_agent\_pool](#input\_windows\_agent\_pool) | Specify the pool for the Windows Agent | `string` | n/a | yes |
| <a name="input_windows_vm_size"></a> [windows\_vm\_size](#input\_windows\_vm\_size) | Windows VM Size | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_id"></a> [kv\_id](#output\_kv\_id) | KV ID for storing agent creds |
| <a name="output_kv_name"></a> [kv\_name](#output\_kv\_name) | KV name for storing agent creds |
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | Resource Group ID |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | Location |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | Resource Group Name |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | Storage account ID |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Storage account name |
| <a name="output_storage_blob_id"></a> [storage\_blob\_id](#output\_storage\_blob\_id) | Blob ID |
| <a name="output_storage_blob_name"></a> [storage\_blob\_name](#output\_storage\_blob\_name) | Blob name |
| <a name="output_storage_blob_url"></a> [storage\_blob\_url](#output\_storage\_blob\_url) | Blob URL |
| <a name="output_storage_container_id"></a> [storage\_container\_id](#output\_storage\_container\_id) | Storage container ID |
| <a name="output_storage_container_name"></a> [storage\_container\_name](#output\_storage\_container\_name) | Storage container name |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet ID |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Subnet name |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | Windows VM ID |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | Windows VM name |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | vNet ID |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | vNet Name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->