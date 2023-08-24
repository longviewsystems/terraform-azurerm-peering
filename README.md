# Solution Description
This module creates Azure Peering between two vNets.  The peering must be configured on both vNets, and so the module configures that.

# References

* [Azure Peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)

# Notes

N/A

# Usage

``` hcl
module "sample_spoke_peering_with_hub_vpn_gateway" {
  source = "https://github.com/longviewsystems/terraform-azurerm-peering"

  providers = {
    azurerm.source = azurerm.hub
    azurerm.destination = azurerm.spoke
  }

  src_peer_name = "peer-src-to-dest"
  dest_peer_name = "peer-dest-to-src"

  vnet_src_id  = azurerm_virtual_network.vnet_src.id
  vnet_dest_id = azurerm_virtual_network.vnet_dst.id

  #By default the following are enabled:
  # Allow access to remote virtual network
  # Allow traffic to remote virtual network
  # Allow traffic forwarded from the remote virtual network (allow gateway transit)

  # If there's a remote gateway, make sure to set it on the src or dest peer, and probably not both.
  use_remote_dest_gateway = true

}

```

---------------

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.destination"></a> [azurerm.destination](#provider\_azurerm.destination) | >= 2.0 |
| <a name="provider_azurerm.source"></a> [azurerm.source](#provider\_azurerm.source) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.peering_dest](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peering_src](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_forwarded_dest_traffic"></a> [allow\_forwarded\_dest\_traffic](#input\_allow\_forwarded\_dest\_traffic) | Option allow\_forwarded\_traffic for the dest vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic | `bool` | `false` | no |
| <a name="input_allow_forwarded_src_traffic"></a> [allow\_forwarded\_src\_traffic](#input\_allow\_forwarded\_src\_traffic) | Option allow\_forwarded\_traffic for the src vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic | `bool` | `false` | no |
| <a name="input_allow_gateway_dest_transit"></a> [allow\_gateway\_dest\_transit](#input\_allow\_gateway\_dest\_transit) | Option allow\_gateway\_transit for the dest vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit | `bool` | `false` | no |
| <a name="input_allow_gateway_src_transit"></a> [allow\_gateway\_src\_transit](#input\_allow\_gateway\_src\_transit) | Option allow\_gateway\_transit for the src vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit | `bool` | `false` | no |
| <a name="input_allow_virtual_dest_network_access"></a> [allow\_virtual\_dest\_network\_access](#input\_allow\_virtual\_dest\_network\_access) | Option allow\_virtual\_network\_access for the dest vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access | `bool` | `false` | no |
| <a name="input_allow_virtual_src_network_access"></a> [allow\_virtual\_src\_network\_access](#input\_allow\_virtual\_src\_network\_access) | Option allow\_virtual\_network\_access for the src vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access | `bool` | `false` | no |
| <a name="input_dest_peer_name"></a> [dest\_peer\_name](#input\_dest\_peer\_name) | The destination peer name. | `string` | n/a | yes |
| <a name="input_src_peer_name"></a> [src\_peer\_name](#input\_src\_peer\_name) | The source peer name. | `string` | n/a | yes |
| <a name="input_use_remote_dest_gateway"></a> [use\_remote\_dest\_gateway](#input\_use\_remote\_dest\_gateway) | Option use\_remote\_gateway for the dest vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways | `bool` | `false` | no |
| <a name="input_use_remote_src_gateway"></a> [use\_remote\_src\_gateway](#input\_use\_remote\_src\_gateway) | Option use\_remote\_gateway for the src vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways | `bool` | `false` | no |
| <a name="input_vnet_dest_id"></a> [vnet\_dest\_id](#input\_vnet\_dest\_id) | ID of the dest vnet to peer | `string` | n/a | yes |
| <a name="input_vnet_src_id"></a> [vnet\_src\_id](#input\_vnet\_src\_id) | ID of the src vnet to peer | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_peering_dest_id"></a> [vnet\_peering\_dest\_id](#output\_vnet\_peering\_dest\_id) | Virtual network dest peering id |
| <a name="output_vnet_peering_dest_name"></a> [vnet\_peering\_dest\_name](#output\_vnet\_peering\_dest\_name) | Virtual network dest peering name |
| <a name="output_vnet_peering_src_id"></a> [vnet\_peering\_src\_id](#output\_vnet\_peering\_src\_id) | Virtual network src peering id |
| <a name="output_vnet_peering_src_name"></a> [vnet\_peering\_src\_name](#output\_vnet\_peering\_src\_name) | Virtual network src peering name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


