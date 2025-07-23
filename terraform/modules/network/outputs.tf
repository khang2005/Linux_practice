output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "Default subnet ID"
  value       = azurerm_subnet.default.id
}
