output "rg_name" {
  value       = azurerm_resource_group.pipeline_agents_rg.name
  description = "Resource Group Name"
}

output "rg_location" {
  value       = azurerm_resource_group.pipeline_agents_rg.location
  description = "Location"
}

output "rg_id" {
  value       = azurerm_resource_group.pipeline_agents_rg.id
  description = "Resource Group ID"
}

output "vnet_name" {
  value       = azurerm_virtual_network.pipeline_agents_vnet.name
  description = "vNet Name"
}

output "vnet_id" {
  value       = azurerm_virtual_network.pipeline_agents_vnet.id
  description = "vNet ID"
}

output "subnet_name" {
  value       = azurerm_subnet.pipeline_agents_subnet.name
  description = "Subnet name"
}

output "subnet_id" {
  value       = azurerm_subnet.pipeline_agents_subnet.id
  description = "Subnet ID"
}

output "storage_account_name" {
  value       = azurerm_storage_account.pipeline_agents_stor_acct.name
  description = "Storage account name"
}

output "storage_account_id" {
  value       = azurerm_storage_account.pipeline_agents_stor_acct.id
  description = "Storage account ID"
}

output "storage_container_name" {
  value       = azurerm_storage_container.pipeline_agents_container_scripts.name
  description = "Storage container name"
}

output "storage_container_id" {
  value       = azurerm_storage_container.pipeline_agents_container_scripts.id
  description = "Storage container ID"
}

output "storage_blob_name" {
  value       = azurerm_storage_blob.pipeline_agents_blob_scripts_1.name
  description = "Blob name"
}

output "storage_blob_id" {
  value       = azurerm_storage_blob.pipeline_agents_blob_scripts_1.id
  description = "Blob ID"
}

output "storage_blob_url" {
  value       = azurerm_storage_blob.pipeline_agents_blob_scripts_1.url
  description = "Blob URL"
}

output "virtual_machine_name" {
  value       = azurerm_windows_virtual_machine.windowsvm.name
  description = "Windows VM name"
}

output "virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.windowsvm.id
  description = "Windows VM ID"
}

output "kv_name" {
  value       = azurerm_key_vault.pipeline_agents_kv.name
  description = "KV name for storing agent creds"
}

output "kv_id" {
  value       = azurerm_key_vault.pipeline_agents_kv.id
  description = "KV ID for storing agent creds"
}