resource "azurerm_virutal_network" "vnet" {
  name = "vnet-${var.env}-${var.region}"
  adress_space = ["10.0.0.0/16"]
  resrouce_group_name= var.resource_group_name
}
