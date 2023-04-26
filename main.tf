
resource "azurerm_virtual_network_peering" "peering_src" {
  provider = azurerm.source

  name = var.src_peer_name
  resource_group_name          = local.vnet_src_resource_group_name
  virtual_network_name         = local.vnet_src_name
  remote_virtual_network_id    = var.vnet_dest_id
  allow_virtual_network_access = var.allow_virtual_src_network_access
  allow_forwarded_traffic      = var.allow_forwarded_src_traffic
  allow_gateway_transit        = var.allow_gateway_src_transit
  use_remote_gateways          = var.use_remote_src_gateway
}

resource "azurerm_virtual_network_peering" "peering_dest" {
  provider = azurerm.destination

  name = var.dest_peer_name
  resource_group_name          = local.vnet_dest_resource_group_name
  virtual_network_name         = local.vnet_dest_name
  remote_virtual_network_id    = var.vnet_src_id
  allow_virtual_network_access = var.allow_virtual_dest_network_access
  allow_forwarded_traffic      = var.allow_forwarded_dest_traffic
  allow_gateway_transit        = var.allow_gateway_dest_transit
  use_remote_gateways          = var.use_remote_dest_gateway
}
