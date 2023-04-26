locals {
  vnet_src_parts               = split("/", var.vnet_src_id)
  vnet_src_name                = element(local.vnet_src_parts, 8)
  vnet_src_resource_group_name = element(local.vnet_src_parts, 4)

  vnet_dest_parts               = split("/", var.vnet_dest_id)
  vnet_dest_name                = element(local.vnet_dest_parts, 8)
  vnet_dest_resource_group_name = element(local.vnet_dest_parts, 4)
}
