data "azurerm_client_config" "current" {}

module "ip" {
  source = "./modules/workstation_public_ip"
}

# Create Resource Group
resource "azurerm_resource_group" "pipeline_agents_rg" {
  name     = var.pipeline_agents_rg
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "pipeline_agents_vnet" {
  name                = var.pipeline_agents_vnet
  location            = azurerm_resource_group.pipeline_agents_rg.location
  resource_group_name = azurerm_resource_group.pipeline_agents_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet
resource "azurerm_subnet" "pipeline_agents_subnet" {
  name                 = var.pipeline_agents_subnet
  resource_group_name  = azurerm_resource_group.pipeline_agents_rg.name
  virtual_network_name = azurerm_virtual_network.pipeline_agents_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create NIC
resource "azurerm_network_interface" "pipeline_agents_nic" {
  name                = var.pipeline_agents_nic
  location            = azurerm_resource_group.pipeline_agents_rg.location
  resource_group_name = azurerm_resource_group.pipeline_agents_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.pipeline_agents_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Storage account
resource "azurerm_storage_account" "pipeline_agents_stor_acct" {
  name                      = var.pipeline_agents_stor_acct
  location                  = azurerm_resource_group.pipeline_agents_rg.location
  resource_group_name       = azurerm_resource_group.pipeline_agents_rg.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

# Create Storage container
resource "azurerm_storage_container" "pipeline_agents_container_scripts" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.pipeline_agents_stor_acct.name
  container_access_type = "private"
}

# Create Blob
resource "azurerm_storage_blob" "pipeline_agents_blob_scripts_1" {
  name                   = "win_agent_install.ps1"
  storage_account_name   = azurerm_storage_account.pipeline_agents_stor_acct.name
  storage_container_name = azurerm_storage_container.pipeline_agents_container_scripts.name
  type                   = "Block"
  source                 = var.agent_script_path
}

# Create KV
resource "azurerm_key_vault" "pipeline_agents_kv" {
  name                            = var.agent_kv_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.pipeline_agents_rg.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled        = var.purge_protection
  enabled_for_deployment          = true
  enabled_for_template_deployment = true

  sku_name = "standard"

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = [module.ip.result]
    virtual_network_subnet_ids = var.allowed_subnet_ids != null ? var.allowed_subnet_ids : null
  }
}

# Create KV access policy
resource "azurerm_key_vault_access_policy" "kvap_opinionated" {
  key_vault_id = azurerm_key_vault.pipeline_agents_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "get",
  ]
  key_permissions = [
    "get",
  ]
  secret_permissions = [
    "set",
    "get",
    "list",
    "delete",
    "purge",
  ]
  storage_permissions = [
    "get",
  ]
}

# Generate random admin username
resource "random_string" "admin_username" {
  length  = 16
  special = false
}

# Generate random admin password
resource "random_password" "admin_password" {
  length      = 24
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

# Create VM
resource "azurerm_windows_virtual_machine" "windowsvm" {
  name                = var.windows_agent_name
  resource_group_name = azurerm_resource_group.pipeline_agents_rg.name
  location            = azurerm_resource_group.pipeline_agents_rg.location
  size                = var.windows_vm_size
  admin_username      = random_string.admin_username.result
  admin_password      = random_password.admin_password.result
  network_interface_ids = [
    azurerm_network_interface.pipeline_agents_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftvisualstudio"
    offer     = "visualstudio2019latest"
    sku       = "vs-2019-comm-latest-ws2019"
    version   = "latest"
  }
}

# Add Agent Node username and password to key vault
resource "azurerm_key_vault_secret" "agent_user" {
  name            = var.agent_kv_user
  value           = random_string.admin_username.result
  key_vault_id    = azurerm_key_vault.pipeline_agents_kv.id
  depends_on      = [azurerm_key_vault_access_policy.kvap_opinionated]
  content_type    = "randomized VM user name"
  expiration_date = "2022-12-31T23:59:59Z"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "agent_pw" {
  name            = var.agent_kv_pass
  value           = random_password.admin_password.result
  key_vault_id    = azurerm_key_vault.pipeline_agents_kv.id
  depends_on      = [azurerm_key_vault_access_policy.kvap_opinionated]
  content_type    = "randomized VM password"
  expiration_date = "2021-12-31T23:59:59Z"

  tags = var.tags
}

# VM custom script extension
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "Win_vm_extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsvm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<EOF
    {
      "fileUris": [
        "${azurerm_storage_blob.pipeline_agents_blob_scripts_1.url}"
      ]
    }
  EOF

  protected_settings = <<EOF
    {
      "commandToExecute"   : "powershell.exe -ExecutionPolicy Unrestricted -File ./win_agent_install.ps1 -AZDO_URL ${var.devops_org_url} -AZDO_PAT ${var.devops_pat} -AZDO_AGENT_POOL ${var.windows_agent_pool} -AZDO_AGENT_NAME ${var.windows_agent_name}",
      "storageAccountName" : "${azurerm_storage_account.pipeline_agents_stor_acct.name}",
      "storageAccountKey"  : "${azurerm_storage_account.pipeline_agents_stor_acct.primary_access_key}"
    }
  EOF

}