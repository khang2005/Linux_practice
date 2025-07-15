provider "azurerm" {
  features {}
  use_oidc = true
}

resource "azurerm_resource_group" "scanner_rg" {
  name     = "PortScannerRG"
  location = "eastus"
}

# Network Security Group
resource "azurerm_network_security_group" "scanner_nsg" {
  name                = "scanner-nsg"
  location            = azurerm_resource_group.scanner_rg.location
  resource_group_name = azurerm_resource_group.scanner_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "scanner_vnet" {
  name                = "scanner-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.scanner_rg.location
  resource_group_name = azurerm_resource_group.scanner_rg.name
}

# Subnet
resource "azurerm_subnet" "scanner_subnet" {
  name                 = "scanner-subnet"
  resource_group_name  = azurerm_resource_group.scanner_rg.name
  virtual_network_name = azurerm_virtual_network.scanner_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "scanner_ip" {
  name                = "ScannerPublicIP"
  resource_group_name = azurerm_resource_group.scanner_rg.name
  location            = azurerm_resource_group.scanner_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "scanner_nic" {
  name                = "scanner-nic"
  location            = azurerm_resource_group.scanner_rg.location
  resource_group_name = azurerm_resource_group.scanner_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.scanner_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.scanner_ip.id
  }
}

# Connect NSG to NIC
resource "azurerm_network_interface_security_group_association" "scanner_nic_nsg" {
  network_interface_id      = azurerm_network_interface.scanner_nic.id
  network_security_group_id = azurerm_network_security_group.scanner_nsg.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "scanner_vm" {
  name                = "ScannerVM"
  resource_group_name = azurerm_resource_group.scanner_rg.name
  location            = azurerm_resource_group.scanner_rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.scanner_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }
}
