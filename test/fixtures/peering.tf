module "peering" {
  source = "../.."

  providers = {
    azurerm.source      = azurerm.hub
    azurerm.destination = azurerm.spoke
  }

  src_peer_name  = "peer-src-to-dest"
  dest_peer_name = "peer-dest-to-src"

  vnet_src_id  = azurerm_virtual_network.vnet_src.id
  vnet_dest_id = azurerm_virtual_network.vnet_dst.id

  allow_forwarded_src_traffic  = true
  allow_forwarded_dest_traffic = true

  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true

}