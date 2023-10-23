# Interface réseau
resource "azurerm_network_interface" "ForLab-vm-suricata-nic" {
  name                = "ForLab-vm-suricata-nic"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name

  ip_configuration {
    name                          = "ForLab-vm-suricata-nic-config"
    subnet_id                     = azurerm_subnet.ForLab-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.99.10.90"
  }
}



resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-suricata-nic-nat" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-suricata-nic.id
  ip_configuration_name = "ForLab-vm-suricata-nic-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-ssh2.id
}

resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-suricata-nic-nat2" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-suricata-nic.id
  ip_configuration_name = "ForLab-vm-suricata-nic-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-http.id
}

# Machine virtuelle
resource "azurerm_linux_virtual_machine" "ForLab-vm-suricata" {
  name                = "ForLab-vm-suricata"
  computer_name       = var.suricata-hostname
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  location            = data.azurerm_resource_group.ForLab-rg.location
  size                = var.suricata-size
  disable_password_authentication = false
  admin_username      = var.linux-user
  admin_password      = random_string.linuxpass.result
  network_interface_ids = [
    azurerm_network_interface.ForLab-vm-wazuh-nic.id,
  ]

  os_disk {
    name                 = "ForLab-vm-suricata-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}