# -----------------------------------------------------------------------------
# Resource Group Outputs
# -----------------------------------------------------------------------------
output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = azurerm_resource_group.this.location
}

# -----------------------------------------------------------------------------
# Virtual Network Outputs
# -----------------------------------------------------------------------------
output "vnet_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network."
  value       = azurerm_virtual_network.this.address_space
}

# -----------------------------------------------------------------------------
# Subnet Outputs
# -----------------------------------------------------------------------------
output "subnet_name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.this.name
}

output "subnet_id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet."
  value       = azurerm_subnet.this.address_prefixes
}
