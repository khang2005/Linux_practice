output "resource_group_name" {
  description = "Main resource group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.network.vnet_id
}
