# TF core-infra
pipeline_agents_rg        = "wnagt_rg"
pipeline_agents_vnet      = "wnagt_vnet"
pipeline_agents_subnet    = "wnagt_subnet"
pipeline_agents_nic       = "wnagt_nic"
pipeline_agents_stor_acct = "wnagtstoracct"
windows_agent_pool        = "Default"
windows_agent_name        = "wnagt"
windows_vm_size           = "Standard_D4s_v3"
agent_script_path         = "./scripts/win_agent_install.ps1"
location                  = "canadacentral"
tags = {
  environment = "test",
  managedBy   = "Terraform"
}
agent_kv_name = "wnagt-kv"
agent_kv_user = "wnagt-kv-user"
agent_kv_pass = "wnagt-kv-pass"

# TF azdo
devops_org_url = "https://dev.azure.com/<ORG>"
devops_pat     = "<PAT TOKEN>"
