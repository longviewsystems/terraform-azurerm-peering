# Read in from environment variables

variable "pipeline_agents_rg" {
  type        = string
  description = "Resource group for build agent"
}

variable "pipeline_agents_vnet" {
  type        = string
  description = "vNet for build agent"
}

variable "pipeline_agents_subnet" {
  type        = string
  description = "Subnet for build agent"
}

variable "pipeline_agents_nic" {
  type        = string
  description = "NIC for build agent"
}

variable "pipeline_agents_stor_acct" {
  type        = string
  description = "Storage account for build agent"
}

variable "windows_agent_pool" {
  type        = string
  description = "Specify the pool for the Windows Agent"
}

variable "windows_agent_name" {
  type        = string
  description = "Name of the Windows Agent"
}

variable "windows_vm_size" {
  type        = string
  description = "Windows VM Size"
}

variable "agent_script_path" {
  type        = string
  description = "Relative location for agent script"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "devops_org_url" {
  type        = string
  description = "Azure DevOps Org URL"
  default     = ""
}

variable "devops_pat" {
  type        = string
  description = "PAT token for Azure DevOps"
  default     = ""
}

variable "agent_kv_name" {
  type        = string
  description = "Name of the Key Vault for the agent"
}

variable "tags" {
  type        = map(string)
  description = "Resource Tags - read in from environment variables if not defined"
  default = {
    "environment" = "test"
    "managedBy"   = "terraform"
  }
}

variable "agent_kv_user" {
  type        = string
  description = "User name for the agent in the KV"
}

variable "agent_kv_pass" {
  type        = string
  description = "Password for the agent in the KV"
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs that are allowed to access the KV"

  default = null
}

variable "purge_protection" {
  type        = string
  description = "Determines if purge protection is enabled or not for the KV"

  default = false
}