resource "azurerm_public_ip" "client" {
  name                = "pip-client"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "client" {
  name                = "nic-client"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.client.id
  }
}

resource "azurerm_windows_virtual_machine" "client" {
  name                  = "vm-client"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.client.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-22h2-pro"
    version   = "latest"
  }
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "client_shutdown_client" {
  virtual_machine_id = azurerm_windows_virtual_machine.client.id
  location           = azurerm_resource_group.this.location
  enabled            = true

  daily_recurrence_time = "2300" 
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled         = false
    time_in_minutes = 30
    webhook_url     = ""
  }
}