variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the domain controller VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the domain controller VM"
  sensitive   = true
}
variable "joiner_password" {
  type        = string
  description = "Password for the joiner account"
  sensitive   = true
}

variable "dummyfoldername" {
  type        = string
  description = "Name of the dummy folder for the AD installation"
}

variable "domain_name" {
  description = "The FQDN of the Active Directory domain"
  type        = string
  default     = "corp.contoso.com"
}

variable "domain_netbios_name" {
  description = "The NetBIOS name for the Active Directory domain"
  type        = string
  default     = "CORP"
}

variable "safemode_pass" {
  description = "Safe Mode Administrator Password (DSRM)"
  type        = string
  sensitive   = true
}


variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "Europe West"
}