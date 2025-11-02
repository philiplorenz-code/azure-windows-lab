output "public_ip_address_dc" {
  value = azurerm_public_ip.dc.ip_address
}

output "public_ip_address_client" {
  value = azurerm_public_ip.client.ip_address
}