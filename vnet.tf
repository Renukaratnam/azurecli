# Virtual Network


resource "azurerm_virtual_network" "renu-vnet" {
  name                = "renu-rg"
  location            = azurerm_resource_group.renu-rg.location
  resource_group_name = azurerm_resource_group.renu-rg.name
  address_space       = ["10.0.0.0/16"]


tags = {
    environment = "dev"
  }

}

# Subnet 

resource "azurerm_subnet" "renu-sn" {
  name                 = "renu-subnet"
  resource_group_name  = azurerm_resource_group.renu-rg.name
  virtual_network_name = azurerm_virtual_network.renu-vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}