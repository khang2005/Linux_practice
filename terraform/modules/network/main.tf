resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-main"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "default" {
  name                 = "snet-${var.environment}-default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 0)]
}
