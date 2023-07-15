resource "azurerm_network_interface" "main" {
  name                = "AlicesNetworkInterface"
  location            = "West Europe"
  resource_group_name = "Alices_Project_Group"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip_id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "AlicesVM"
  location            = "West Europe"
  resource_group_name = "Alices_Project_Group"
  size                = "Standard_B1s"
  admin_username      = "christian"
  admin_password      = "christianspassword"
  network_interface_ids = [azurerm_network_interface.main.id]
  #admin_ssh_key {
  #  username   = "christian"
  #  public_key = "ssh-rsa jfQYIGwX9odHh6BlfBA+Uu4wZZHDlZaNV/tZv/zhyes christian@cc-75698b48-5fcb98799f-mnprr"
  #}
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
