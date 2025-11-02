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

output "vm_details" {
  description = "List of all VMs with name, private/public IP, username and password."
  sensitive   = true
  value = [
    for idx in range(var.vm_count) : {
      name        = azurerm_windows_virtual_machine.this[idx].name
      private_ip  = azurerm_network_interface.nic[idx].private_ip_address
      public_ip   = var.public_ip ? azurerm_public_ip.this[idx].ip_address : null
      username    = var.admin_username
      password    = var.admin_password
    }
  ]
}
