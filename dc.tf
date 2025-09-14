resource "azurerm_public_ip" "dc" {
  name                = "pip-ad-dc"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}


resource "azurerm_network_security_group" "dc" {
  name                = "nsg-ad-dc"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_dc" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.dc.id
}


resource "azurerm_network_interface" "dc" {
  name                = "nic-ad-dc"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dc.id
  }
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                  = "vm-ad-dc"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.dc.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "disk-ad-dc-data"
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.dc.id
  lun                = 0
  caching            = "ReadOnly"
}




resource "azurerm_dev_test_global_vm_shutdown_schedule" "client_shutdown_dc" {
  virtual_machine_id = azurerm_windows_virtual_machine.dc.id
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