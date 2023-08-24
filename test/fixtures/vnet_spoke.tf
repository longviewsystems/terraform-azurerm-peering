/*****************************************
/*   naming_spoke conventions
/*****************************************/
# https://github.com/Azure/terraform-azurerm-naming_spoke
module "naming_spoke" {
  source  = "Azure/naming/azurerm"
  version = "0.1.1"
  suffix  = ["networking"]
  prefix  = ["spoke"]

  unique-include-numbers = false
  unique-length          = 4
}

/*****************************************
/*   Resource Group
/*****************************************/

resource "azurerm_resource_group" "rg_spoke" {
  provider = azurerm.spoke
  name     = module.naming_spoke.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

/*****************************************
/*   vNet
/*****************************************/

resource "azurerm_virtual_network" "vnet_spoke" {
  provider            = azurerm.spoke
  name                = module.naming_spoke.virtual_network.name_unique
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_spoke.location
  resource_group_name = azurerm_resource_group.rg_spoke.name
  tags                = var.tags
}

# subnet
resource "azurerm_subnet" "subnet_spoke" {
  provider             = azurerm.spoke
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_spoke.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["10.1.1.0/24"]
}
