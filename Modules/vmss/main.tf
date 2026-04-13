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
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Welcome from VMSS 🚀</h1>" > /var/www/html/index.html
EOF
)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}