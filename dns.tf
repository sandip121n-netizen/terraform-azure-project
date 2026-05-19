resource "azurerm_private_dns_zone" "dns" {
  name                = "internal.local"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_vnet1" {
  name                  = "link-vnet1"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = module.network.vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_vnet2" {
  name                  = "link-vnet2"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = module.peering.vnet2_id
}

resource "azurerm_private_dns_a_record" "backend" {
  name                = "backend"
  zone_name           = azurerm_private_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = ["10.1.1.4"]   # your VM private IP
}