# -----------------------------------------------------------------------------
# Network Interface(s)
# -----------------------------------------------------------------------------
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${var.name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.this[count.index].id : null
  }
}

# -----------------------------------------------------------------------------
# Optional Public IPs
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "this" {
  count               = var.public_ip ? var.vm_count : 0
  name                = "pip-${var.name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# -----------------------------------------------------------------------------
# Windows Virtual Machines
# -----------------------------------------------------------------------------
resource "azurerm_windows_virtual_machine" "this" {
  count                 = var.vm_count
  name                  = "${var.name}-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = var.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }


  tags = merge(
    {
      Role      = var.enable_dc_features ? "DomainController" : "Client"
      CreatedBy = "Terraform"
      Name      = "${var.name}-${count.index + 1}"
    },
    var.additional_tags
  )
}

# -----------------------------------------------------------------------------
# Optional: Promote to Domain Controller
# -----------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "configure_ad" {
  count                = var.enable_dc_features ? var.vm_count : 0
  name                 = "setup-ad-ds-${count.index + 1}"
  virtual_machine_id   = azurerm_windows_virtual_machine.this[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = [
      "https://raw.githubusercontent.com/philiplorenz-code/azure-windows-lab/main/scripts/install-ad.ps1"
    ]
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File install-ad.ps1 -DomainName ${var.domain_name} -SafeModePass ${var.safemode_pass} -DomainNetbiosName ${var.domain_netbios_name}"
  })

  tags = {
    timestamp = timestamp()
  }
}
