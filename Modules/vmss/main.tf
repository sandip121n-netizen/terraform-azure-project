resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "demo-vmss"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "azureuser"

  disable_password_authentication = false
  admin_password                  = "Password1234!"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [
        var.backend_pool_id
      ]
    }
  }

custom_data = base64encode(<<EOF
#!/bin/bash

apt-get update -y

# Install dependencies
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
apt-get install -y docker.io

# Enable Docker
systemctl enable docker
systemctl start docker

# Pull and run nginx container
docker pull nginx
docker run -d -p 80:80 --name nginx-container nginx

EOF
)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}