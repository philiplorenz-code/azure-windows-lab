resource "azurerm_resource_group" "this" {
  name     = "rg-ad-dc-lab-azure"
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-windows-lab-azure"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "subnet-windows-lab-azure"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}
