# Terraform initialization
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.98.0"
    }
  }

  required_version = ">= 1.1.5"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Specify where the custom data file is for WinRM initialization
locals {
    custom_data_content  = base64encode(file("${path.module}/files/ConfigureRemotingForAnsible.ps1"))
}

# Generate random password for windows local admins
resource "random_string" "windowspass" {
  length           = 16
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}

# Generate random password for linux local admins
resource "random_string" "linuxpass" {
  length           = 16
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}


# Get a reference to the existing resource group(s)
data "azurerm_resource_group" "ForLab-rg" {
  name = var.resource-group
}