terraform {
  required_version = ">= 1"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">=3.0.0, <4.0.0"
      configuration_aliases = [azurerm.source, azurerm.destination]
    }
  }
}
