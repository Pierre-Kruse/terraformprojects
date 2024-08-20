terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-terraform" {
  name     = "rg-terraform01"
  location = "West Europe"
  tags = {
    environment = "dev"
    CostCenter  = "Pkrtechsub"
  }
}

resource "azurerm_virtual_network" "vnet-spoke" {
  name = "vnet-spoke-2"
  resource_group_name = azurerm_resource_group.rg-terraform.name
  location = azurerm_resource_group.rg-terraform.location
  address_space = ["10.64.2.0/24"]

  subnet {
  name           = "subnet1"
  address_prefixes = "10.64.2.20/28"

  tags = {
  environment = "dev"
  CostCenter  = "Pkrtechsub"
  }

}
}
