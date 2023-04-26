terraform {
  required_version = ">= 1"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 2.0"
      configuration_aliases = [azurerm.source, azurerm.destination]
    }
  }
}
