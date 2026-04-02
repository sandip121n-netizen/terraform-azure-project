variable "vm_count" {
  default = 2
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_count

  name = count.index == 0 ? "demo-pip" : "demo-pip-${count.index + 1}"
  
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"

  sku = "Standard"   # ✅ MUST ADD
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name = "demo-nic-${count.index == 0 ? 1 : count.index + 1}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_association" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.backend_pool_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name = "demo-vm-${count.index == 0 ? 1 : count.index + 1}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "Password1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
%{ if count.index == 0 }
echo "<h1>Welcome Sandeep - Terraform VM 🚀</h1>" > /var/www/html/index.html
%{ else }
echo "<h1>Welcome from VM ${count.index + 1} 🚀</h1>" > /var/www/html/index.html
%{ endif }

EOF
)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  lifecycle {
  ignore_changes = [custom_data]
 }
}

