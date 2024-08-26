/*****************************************
/*   Naming conventions
/*****************************************/
# https://github.com/Azure/terraform-azurerm-naming
module "naming_hub" {
  source  = "Azure/naming/azurerm"
  version = "0.1.1"
  suffix  = ["networking"]
  prefix  = ["hub"]

  unique-include-numbers = false
  unique-length          = 4
}

/*****************************************
/*   Resource Group
/*****************************************/

resource "azurerm_resource_group" "rg_hub" {
  provider = azurerm.hub
  name     = module.naming_hub.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

/*****************************************
/*   vNet
/*****************************************/

resource "azurerm_virtual_network" "vnet_hub" {
  provider            = azurerm.hub
  name                = module.naming_hub.virtual_network.name_unique
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  tags                = var.tags
}

# subnet
resource "azurerm_subnet" "subnet_hub" {
  provider             = azurerm.hub
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "hub" {
  name                = "test" #module.naming_hub.public_ip.name_unique
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hub" {
  name                = module.naming_hub.virtual_network_gateway.name_unique
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_hub.id
  }
}