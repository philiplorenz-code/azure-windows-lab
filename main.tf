terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1cea4233-25fd-4df7-8355-60b5d7064bae"
}

module "common" {
  source = "./modules/common"

  location            = "germanywestcentral"
}

module "clients" {
  source              = "./modules/vm"
  name                = "client"
  resource_group_name = module.common.resource_group_name
  location            = module.common.resource_group_location
  subnet_id           = module.common.subnet_id

  admin_username = "pwsh-admin"
  admin_password = "ComplexPassword!234"

  vm_count  = 8
  public_ip = true
  windows_sku = "2019-datacenter"

  size = "Standard_B2ms"

  enable_dc_features = false 

  source_image_reference = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-22h2-pro"
    version   = "latest"
  }
}