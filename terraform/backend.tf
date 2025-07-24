terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"            # Must be hardcoded
    storage_account_name = "tfstatedev55768"       # Must be hardcoded
    container_name       = "tfstate"               # Must be hardcoded
    key                  = "dev.terraform.tfstate" # Must be hardcoded
  }
}
