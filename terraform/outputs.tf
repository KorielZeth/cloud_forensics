output "region" {
  value = data.azurerm_resource_group.ForLab-rg.location
  description = "La région (au sens Cloud du terme) dans laquelle les ressources seront déployées"
}

output "public-ip" {
  value = azurerm_public_ip.ForLab-ip.ip_address
  description = "L'IP publique utilisée pour se connecter au lab"
}

output "public-ip-dns" {
  value = azurerm_public_ip.ForLab-ip.fqdn
  description = "Le nom DNS public utilisé pour se connecter au lab"
}

output "public-ip-outbound" {
    value = azurerm_public_ip.ForLab-ip-outbound.ip_address
    description = "L'adresse IP publique utilisée par les machines du lab pour se connecter à internet"
}

output "ip-whitelist" {
    value = join(", ", var.ip-whitelist)
    description = "Les adresses IP autorisées à se connecter aux interfaces du lab"
}

output "wazuh-url" {
    value = "https://10.19.10.50/"
    description = "L'URL utilisée pour se connecter au dashboard Wazuh (warning sur le certificat)"
}

#output "wazuh-user" {
#    value = "wazuh"
#    description = "The username to connect to wazuh."
#}

#output "wazuh-password" {
#    value = random_string.linuxpass.result
#    description = "The password to connect to wazuh."
#}

output "linux-user" {
    value = var.linux-user
    description = "Le username utilisé pour se connecter aux machines Linux"
}

output "linux-password" {
    value = random_string.linuxpass.result
    description = "Le mot de passe utilisé pour les comptes admins Linux"
}

output  "windows-domain" {
    value = var.domain-dns-name
    description = "Le nom de domaine Active Directory"
}

output "windows-user" {
    value = var.windows-user
    description = "Le username utilisé pour se connecter aux machines Windows"
}

output "windows-password" {
    value = random_string.windowspass.result
    description = "Le mot de passe utilisé pour les comptes admins Windows"
}

output "attackbox-hostname" {
    value = var.attackbox-hostname
    description = "Le hostname de la VM d'attaque"
}

output "wazuh-hostname" {
    value = var.wazuh-hostname
    description = "Le hostname de la VM hébergeant le stack Wazuh"
}

output "dc-hostname" {
    value = var.dc-hostname
    description = "Le hostname du DC"
}

output "win10-hostname"{
    value = var.win10-hostname
    description = "Le hostname de la VM Windows 10"
}