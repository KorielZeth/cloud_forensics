# Initialisation du provider Terraform // Initialization of the Terraform provider
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

# Specify where the custom data file is for WinRM initialization // Précise l'emplacement du fichier chargé de la config WinRM
locals {
    custom_data_content  = base64encode(file("${path.module}/files/ConfigureRemotingForAnsible.ps1"))
}

# Generate random password for windows local admins // Création du mot de passe pour l'admin Windows
resource "random_string" "windowspass" {
  length           = 16
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}

# Generate random password for linux local admins // Création du mot de passe pour l'admin Linux
resource "random_string" "linuxpass" {
  length           = 16
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}


# Get a reference to the existing resource group(s) // Réference au groupe de ressource sélectionné
data "azurerm_resource_group" "ForLab-rg" {
  name = var.resource-group
}