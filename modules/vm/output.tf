# -----------------------------------------------------------------------------
# Outputs for VM module
# -----------------------------------------------------------------------------

output "vm_names" {
  description = "List of VM names created by this module."
  value       = [for vm in azurerm_windows_virtual_machine.this : vm.name]
}

output "vm_ids" {
  description = "List of VM IDs created by this module."
  value       = [for vm in azurerm_windows_virtual_machine.this : vm.id]
}

output "private_ips" {
  description = "List of private IP addresses for the NICs."
  value       = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}

output "public_ips" {
  description = "List of public IPs if created (empty if not)."
  value       = var.public_ip ? [for pip in azurerm_public_ip.this : pip.ip_address] : []
}

output "network_interface_ids" {
  description = "List of NIC IDs created for the VMs."
  value       = [for nic in azurerm_network_interface.nic : nic.id]
}
