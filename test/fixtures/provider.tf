terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0, <4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  #alias           = "hub"  #default subscription.
  subscription_id = "7f3c4fcf-626c-49e0-9160-a756147abaa4" #SUB-LVS-CMP-DEV
  tenant_id       = "fd6fb306-2acd-4fae-a721-c8f5714b622e"
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = "7f3c4fcf-626c-49e0-9160-a756147abaa4" #SUB-LVS-CMP-DEV
  tenant_id       = "fd6fb306-2acd-4fae-a721-c8f5714b622e"
}

provider "azurerm" {
  features {}
  alias           = "spoke"
  subscription_id = "fdd234dc-7c17-4710-958a-2fc1fb7ba842" #SUB-LVS-CMP-DEV2
  tenant_id       = "fd6fb306-2acd-4fae-a721-c8f5714b622e"
}