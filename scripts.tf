resource "azurerm_virtual_machine_extension" "provision_and_configure_ad" {
  name                 = "setup-ad-ds"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
    "fileUris": [
      "https://raw.githubusercontent.com/philiplorenz-code/azure-windows-lab/main/scripts/install-ad.ps1"
    ],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-ad.ps1 -DomainName ${var.domain_name} -SafeModePass ${var.safemode_pass} -DomainNetbiosName ${var.domain_netbios_name}"
  }
  SETTINGS

  tags = {
    timestamp = "${timestamp()}"
  }
}



resource "null_resource" "create_joiner_user" {
  provisioner "local-exec" {
    command = <<EOT
      az vm run-command invoke \
        --command-id RunPowerShellScript \
        --name ${azurerm_windows_virtual_machine.dc.name} \
        --resource-group ${azurerm_resource_group.this.name} \
        --scripts @"${path.module}/scripts/create-joiner-account.ps1" \
        --parameters DomainName=${var.domain_name} JoinerPassword=${var.joiner_password}
    EOT
  }

  depends_on = [
    azurerm_virtual_machine_extension.provision_and_configure_ad
  ]
}



resource "azurerm_virtual_machine_extension" "join_domain" {
  name                 = "join-domain"
  virtual_machine_id   = azurerm_windows_virtual_machine.client.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
    "fileUris": [
      "https://raw.githubusercontent.com/philiplorenz-code/azure-windows-lab/main/scripts/join-domain.ps1"
    ],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File join-domain.ps1 -DomainName ${var.domain_name} -DomainJoinUser ${var.domain_netbios_name}\\Joiner -DomainJoinPassword ${var.joiner_password} -DnsServer ${azurerm_network_interface.dc.private_ip_address}"
  }
  SETTINGS

  tags = {
    timestamp = "${timestamp()}"
  }

  depends_on = [
    azurerm_virtual_machine_extension.provision_and_configure_ad,
    null_resource.create_joiner_user
  ]
}



resource "null_resource" "set_language" {
  depends_on = [azurerm_virtual_machine_extension.join_domain]
  provisioner "local-exec" {
    command = <<EOT
      az vm run-command invoke \
        --command-id RunPowerShellScript \
        --name ${azurerm_windows_virtual_machine.client.name} \
        --resource-group ${azurerm_resource_group.this.name} \
        --scripts @"${path.module}/scripts/wsl/language.ps1"
    EOT
  }
}


resource "null_resource" "install_wsl" {
  depends_on = [null_resource.set_language]

  provisioner "local-exec" {
    command = <<EOT
      az vm run-command invoke \
        --command-id RunPowerShellScript \
        --name ${azurerm_windows_virtual_machine.client.name} \
        --resource-group ${azurerm_resource_group.this.name} \
        --scripts @"${path.module}/scripts/wsl/install-wsl.ps1"
    EOT
  }
}

resource "null_resource" "post_reboot" {
  depends_on = [null_resource.install_wsl]

  provisioner "local-exec" {
    command = <<EOT
      az vm restart \
        --name ${azurerm_windows_virtual_machine.client.name} \
        --resource-group ${azurerm_resource_group.this.name}
    EOT
  }
}

resource "null_resource" "configure_wsl" {
  depends_on = [null_resource.post_reboot]

  provisioner "local-exec" {
    command = <<EOT
      az vm run-command invoke \
        --command-id RunPowerShellScript \
        --name ${azurerm_windows_virtual_machine.client.name} \
        --resource-group ${azurerm_resource_group.this.name} \
        --scripts @"${path.module}/scripts/wsl/configure-wsl.ps1"
    EOT
  }
}
