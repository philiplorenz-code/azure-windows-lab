variable "name" {
  description = "Base name for the virtual machine(s)."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be deployed."
  type        = string
}

variable "size" {
  description = "The size (SKU) of the virtual machine(s)."
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "Administrator username for the virtual machine(s)."
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the virtual machine(s)."
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "The ID of the subnet where the virtual machine(s) will be connected."
  type        = string
}

variable "public_ip" {
  description = "Whether to assign a public IP to each virtual machine."
  type        = bool
  default     = false
}

variable "vm_count" {
  description = "Number of virtual machines to create."
  type        = number
  default     = 1
}

variable "windows_sku" {
  description = "Windows Server SKU to deploy (e.g. '2022-datacenter', '2019-datacenter')."
  type        = string
  default     = "2022-datacenter"
}

variable "enable_dc_features" {
  description = "Whether to enable Domain Controller setup via Custom Script Extension."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "AD Domain Name (only required if enable_dc_features = true)."
  type        = string
  default     = ""
}

variable "domain_netbios_name" {
  description = "NetBIOS name for the domain (only required if enable_dc_features = true)."
  type        = string
  default     = ""
}

variable "safemode_pass" {
  description = "Safe Mode Administrator password for DC promotion."
  type        = string
  default     = ""
  sensitive   = true
}

variable "additional_tags" {
  description = "Optional map of additional tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "source_image_reference" {
  description = "Source image reference for the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}
