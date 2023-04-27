/*****************************************
/*   naming_dst conventions
/*****************************************/
# https://github.com/Azure/terraform-azurerm-naming_dst
module "naming_dst" {
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

resource "azurerm_resource_group" "rg_dst" {
  provider = azurerm.spoke
  name     = module.naming_dst.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

/*****************************************
/*   vNet
/*****************************************/

resource "azurerm_virtual_network" "vnet_dst" {
  provider            = azurerm.spoke
  name                = module.naming_dst.virtual_network.name_unique
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_dst.location
  resource_group_name = azurerm_resource_group.rg_dst.name
  tags                = var.tags
}

# subnet
resource "azurerm_subnet" "subnet_dst" {
  provider             = azurerm.spoke
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_dst.name
  virtual_network_name = azurerm_virtual_network.vnet_dst.name
  address_prefixes     = ["10.1.1.0/24"]
}
