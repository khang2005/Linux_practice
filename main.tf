terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration= true
}

# Update main.tf with unique naming
resource "azurerm_resource_group" "example" {
  name     = "rg-linuxpractice-${formatdate("YYYYMMDD", timestamp())}"
  location = "eastus"
  tags = {
    ManagedBy = "Terraform"
  }
}
