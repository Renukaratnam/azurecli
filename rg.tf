# Resource Group

resource "azurerm_resource_group" "renu-rg" {
  name     = "az-tf-rg"
  location = "East US"

tags = {
    environment = "dev"
  }
}




