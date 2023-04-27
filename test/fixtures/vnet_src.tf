/*****************************************
/*   Naming conventions
/*****************************************/
# https://github.com/Azure/terraform-azurerm-naming
module "naming_src" {
  source  = "Azure/naming/azurerm"
  version = "0.1.1"
  suffix  = ["networking"]
  prefix  = ["net-b"]

  unique-include-numbers = false
  unique-length          = 4
}

/*****************************************
/*   Resource Group
/*****************************************/

resource "azurerm_resource_group" "rg_src" {
  provider = azurerm.hub
  name     = module.naming_src.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

/*****************************************
/*   vNet
/*****************************************/

resource "azurerm_virtual_network" "vnet_src" {
  provider            = azurerm.hub
  name                = module.naming_src.virtual_network.name_unique
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_src.location
  resource_group_name = azurerm_resource_group.rg_src.name
  tags                = var.tags
}

# subnet
resource "azurerm_subnet" "subnet_src" {
  provider             = azurerm.hub
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_src.name
  virtual_network_name = azurerm_virtual_network.vnet_src.name
  address_prefixes     = ["10.0.1.0/24"]
}
