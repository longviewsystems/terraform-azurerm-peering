#!/usr/bin/env pwsh

param (
    [string]$AZDO_URL,
    [string]$AZDO_PAT,
    [string]$AZDO_AGENT_POOL,
    [string]$AZDO_AGENT_NAME
)

Start-Transcript
Write-Host "Starting agent install"

# Create Folder
New-Item -ItemType Directory -Force -Path "c:\agent"
Set-Location "c:\agent"

# Get the latest agent version
$agentVersion = Invoke-WebRequest https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest -UseBasicParsing
$agentPackage = ($agentVersion | ConvertFrom-Json)[0].tag_name
$agentPackage = $agentPackage.Substring(1)
$agentUrl = "https://vstsagentpackage.azureedge.net/agent/$agentPackage/vsts-agent-win-x64-$agentPackage.zip"

# Download the agent
Invoke-WebRequest $agentUrl -Out agent.zip

# Extract the zip file
Expand-Archive -Path agent.zip -DestinationPath $PWD

# Unattended config script
# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops#unattended-config
.\config.cmd --unattended --url "$AZDO_URL" --auth pat --token "$AZDO_PAT" --pool "$AZDO_AGENT_POOL" --agent "$AZDO_AGENT_NAME" --acceptTeeEula --runAsService --windowsLogonAccount "NT AUTHORITY\NETWORK SERVICE"

# Install Az PowerShell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$False -Force
Install-Module -Name Az -AllowClobber -Confirm:$False -Scope AllUsers -Force

#exit
Stop-Transcript
exit 0