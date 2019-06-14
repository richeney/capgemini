resource "azurerm_resource_group" "rg" {
  name     = "capgemini-test"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
   name                 = "deleteme"
   location             = "West Europe"
   resource_group_name  = "${azurerm_resource_group.rg.name}"
   address_space        = [ "10.0.0.0/16" ]
   dns_servers          = [ "1.1.1.1", "1.0.0.1" ]
}

resource "azurerm_subnet" "subnet" {
   name                 = "deleteme"
   resource_group_name  = "${azurerm_resource_group.rg.name}"
   virtual_network_name = "${azurerm_virtual_network.vnet.name}"
   address_prefix       = "10.0.1.0/24"
}