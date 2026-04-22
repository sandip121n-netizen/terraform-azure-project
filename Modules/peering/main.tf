data "azurerm_virtual_network" "existing_vnet" {
  name                = "demo-vnet"
  resource_group_name = "terraform-demo-rg"
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-2"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network_peering" "old_to_new" {
  name                      = "old-to-new"
  resource_group_name       = var.rg_name
  virtual_network_name      = data.azurerm_virtual_network.existing_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id

  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "new_to_old" {
  name                      = "new-to-old"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = data.azurerm_virtual_network.existing_vnet.id

  allow_virtual_network_access = true
}