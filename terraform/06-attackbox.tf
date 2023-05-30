# Network Interface
resource "azurerm_network_interface" "ForLab-vm-attackbox-nic" {
  name                = "ForLab-vm-attackbox-nic"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name

  ip_configuration {
    name                          = "ForLab-vm-attackbox-nic-config"
    subnet_id                     = azurerm_subnet.ForLab-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.99.10.60"
  }
}

resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-attackbox-nic-nat" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-attackbox-nic.id
  ip_configuration_name = "ForLab-vm-attackbox-nic-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-ssh.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "ForLab-vm-attackbox" {
  name                = "ForLab-vm-attackbox"
  computer_name       = var.attackbox-hostname
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  location            = data.azurerm_resource_group.ForLab-rg.location
  size                = var.attackbox-size
  disable_password_authentication = false
  admin_username      = var.linux-user
  admin_password      = random_string.linuxpass.result
  network_interface_ids = [
    azurerm_network_interface.ForLab-vm-attackbox-nic.id,
  ]

  os_disk {
    name                 = "ForLab-vm-attackbox-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}