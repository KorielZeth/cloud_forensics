variable "resource-group" {
  type        = string
  description = "The name of the sandbox resource group."
}

variable "timezone" {
  type        = string
  description = "The timezone of the lab VMs."
  default     = "W. Europe Standard Time"
}

variable "ip-whitelist" {
  description = "A list of CIDRs that will be allowed to access the exposed services."
  type        = list(string)
}

variable "domain-name-label" {
  description = "The DNS name of the Azure public IP."
  type        = string
  default     = "ForLab"
}

variable "domain-dns-name" {
  description = "The DNS name of the Active Directory domain."
  type        = string
  default     = "For.lab"
}

variable "attackbox-hostname" {
  type = string
  description = "The hostname of the attacker VM."
  default = "attackbox"
}

variable "attackbox-size" {
  type = string
  description = "The machine size of the attacker VM."
  default = "Standard_B4ms"
}

variable "wazuh-hostname" {
  type = string
  description = "The hostname of the wazuh VM."
  default = "wazuh"
}

variable "wazuh-size" {
  type = string
  description = "The machine size of the wazuh VM."
  default = "Standard_B4ms"
}

variable "dc-hostname" {
  type = string
  description = "The hostname of the Windows Server 2016 DC VM."
  default = "dc"
}

variable "dc-size" {
  type = string
  description = "The machine size of the Windows Server 2016 DC VM."
  default = "Standard_B4ms"
}


variable "win10-hostname" {
  type = string
  description = "The hostname of the Windows 10 VM."
  default = "win10"
}

variable "win10-size" {
  type = string
  description = "The machine size of the Windows 10 VM."
  default = "Standard_B4ms"
}

variable "windows-user" {
  type        = string
  description = "The local administrative username for Windows machines. Password will be generated."
  default     = "labadmin"
}  

variable "linux-user" {
  type        = string
  description = "The username used to access Linux machines via SSH."
  default     = "labadmin"
}