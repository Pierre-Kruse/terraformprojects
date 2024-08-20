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
  name                = "vnet-spoke-2"
  resource_group_name = azurerm_resource_group.rg-terraform.name
  location            = azurerm_resource_group.rg-terraform.location
  address_space       = ["10.64.2.0/24"]

  tags = {
    environment = "dev"
    CostCenter  = "Pkrtechsub"
  }
}

resource "azurerm_subnet" "pkrtech-sn" {
  name                 = "sn-frontend"
  resource_group_name  = azurerm_resource_group.rg-terraform.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.64.2.16/28"]
}

resource "azurerm_network_security_group" "example-nsg" {
  name                = "nsg-pkrtechtf01"
  location            = azurerm_resource_group.rg-terraform.location
  resource_group_name = azurerm_resource_group.rg-terraform.name

  tags = {
    environment = "dev"
    CostCenter  = "Pkrtechsub"
  }
}

resource "azurerm_network_security_group" "nsg-rule-01" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.rg-terraform.location
  resource_group_name = azurerm_resource_group.rg-terraform.name

  security_rule {
    name                       = "firstruletf01"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    CostCenter  = "Pkrtechsub"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-to-subnet" {
  subnet_id                 = azurerm_subnet.pkrtech-sn.id
  network_security_group_id = azurerm_network_security_group.example-nsg.id
}

