provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "ADDA84-CTP"
}

data "azurerm_virtual_network" "tp4" {
  name                = "network-tp4"
  resource_group_name = data.azurerm_resource_group.example.name
}

data "azurerm_subnet" "tp4" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = data.azurerm_virtual_network.tp4.name
}

resource "azurerm_public_ip" "example" {
  name                = "publicip"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                      = "nic"
  resource_group_name       = data.azurerm_resource_group.example.name
  location                  = data.azurerm_resource_group.example.location
  enable_ip_forwarding      = false

  ip_configuration {
    name                          = "config"
    subnet_id                     = data.azurerm_subnet.tp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "tls_private_key" "example" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

output "tls_private_key" {
    value = tls_private_key.example.private_key_pem
    sensitive = true
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "devops-20211033"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_D2s_v3"
  admin_username      = "devops"
  network_interface_ids = [azurerm_network_interface.example.id]

  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.example.public_key_openssh
  }

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
