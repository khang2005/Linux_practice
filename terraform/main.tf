# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-main"
  location = var.location
  tags     = var.tags
}

# Network Module
module "network" {
  source = "./modules/network"

  environment         = var.environment
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = "10.${index(["dev", "stage", "prod"], var.environment)}.0.0/16"
}
