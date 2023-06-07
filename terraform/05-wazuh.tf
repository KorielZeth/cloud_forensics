# Interface réseau
resource "azurerm_network_interface" "ForLab-vm-wazuh-nic" {
  name                = "ForLab-vm-wazuh-nic"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name

  ip_configuration {
    name                          = "ForLab-vm-wazuh-nic-config"
    subnet_id                     = azurerm_subnet.ForLab-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.99.10.50"
  }
}



resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-wazuh-nic-nat" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-wazuh-nic.id
  ip_configuration_name = "ForLab-vm-wazuh-nic-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-ssh2.id
}

resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-wazuh-nic-nat" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-wazuh-nic.id
  ip_configuration_name = "ForLab-vm-wazuh-nic-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-http.id
}

# Machine virtuelle (attention, le serv Wazuh nécessite deux coeur et 4g de RAM, une Standard_B4ms suffit)
resource "azurerm_linux_virtual_machine" "ForLab-vm-wazuh" {
  name                = "ForLab-vm-wazuh"
  computer_name       = var.wazuh-hostname
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  location            = data.azurerm_resource_group.ForLab-rg.location
  size                = var.wazuh-size
  disable_password_authentication = false
  admin_username      = var.linux-user
  admin_password      = random_string.linuxpass.result
  network_interface_ids = [
    azurerm_network_interface.ForLab-vm-wazuh-nic.id,
  ]

  os_disk {
    name                 = "ForLab-vm-wazuh-osdisk"
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