# backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatee224b304"  # Manual name using part of your sub ID
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
