resource "azurerm_resource_group" "rg" {
  name     = "terraform-demo-rg"
  location = "East US"
}

module "network" {
  source   = "./Modules/network"
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  
}

module "nsg" {
  source   = "./Modules/nsg"
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  subnet_id = "/subscriptions/5a0855b9-426d-429e-83a9-ea7c4796e9a4/resourceGroups/terraform-demo-rg/providers/Microsoft.Network/virtualNetworks/demo-vnet/subnets/demo-subnet"
}


module "vm" {
  source    = "./Modules/vm"
  rg_name   = azurerm_resource_group.rg.name
  location  = azurerm_resource_group.rg.location
  subnet_id = module.network.subnet_id
  vm_count  = 2
  backend_pool_id  = module.lb.backend_pool_id
}

# resource "azurerm_subnet_network_security_group_association" "nsg_subnet" {
#   subnet_id                 = module.network.subnet_id
#   network_security_group_id = module.nsg.nsg_id
# }

# module "storage" {
#   source              = "./modules/storage"
#   storage_name        = var.storage_name
#   resource_group_name = module.rg.name
#   location            = var.location
# }

module "lb" {
  source   = "./Modules/lb"
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}