locals {
  #assume the src is the hub and the dest is the spoke

}

module "peering" {
  source = "../.."

  providers = {
    azurerm.source      = azurerm.hub
    azurerm.destination = azurerm.spoke
  }

  src_peer_name  = "peer-hub-to-spoke"
  dest_peer_name = "peer-spoke-to-hub"

  vnet_src_id  = azurerm_virtual_network.vnet_hub.id
  vnet_dest_id = azurerm_virtual_network.vnet_spoke.id

  use_remote_dest_gateway = true

}