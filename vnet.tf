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

# network security group

resource "azurerm_network_security_group" "renu-nsg" {
  name                = "tf-ssh-http"
  location            = azurerm_resource_group.renu-rg.location
  resource_group_name = azurerm_resource_group.renu-rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "http"
    priority                   = 510
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "dev"
  }
}

# associate subnet with nsg

resource "azurerm_subnet_network_security_group_association" "renu-nsg-sn" {
 subnet_id          = azurerm_subnet.renu-sn.id
network_security_group_id  = azurerm_network_security_group.renu-nsg.id
}


# public ip
resource "azurerm_public_ip" "renu-pip" {
  name                = "web-pip"
  resource_group_name = azurerm_resource_group.renu-rg.name
  location            = azurerm_resource_group.renu-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

# nic
resource "azurerm_network_interface" "renu-nic" {
  name                = "web-nic"
  location            = azurerm_resource_group.renu-rg.location
  resource_group_name = azurerm_resource_group.renu-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.renu-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.renu-pip.id
  }
}
