# Interface réseau
resource "azurerm_network_interface" "ForLab-vm-dc-nic" {
  name                 = "ForLab-vm-dc-nic"
  location             = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name  = data.azurerm_resource_group.ForLab-rg.name

  ip_configuration {
    name                          = "ForLab-vm-dc-config"
    subnet_id                     = azurerm_subnet.ForLab-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.99.10.10"
  }
}


resource "azurerm_network_interface_nat_rule_association" "ForLab-vm-dc-nic-nat" {
  network_interface_id  = azurerm_network_interface.ForLab-vm-dc-nic.id
  ip_configuration_name = "ForLab-vm-dc-config"
  nat_rule_id           = azurerm_lb_nat_rule.ForLab-lb-nat-rdp2.id
}


# Machine virtuelle
resource "azurerm_windows_virtual_machine" "ForLab-vm-dc" {
  name                     = "ForLab-vm-dc"
  computer_name            = var.dc-hostname
  size                     = var.dc-size
  provision_vm_agent       = true
  enable_automatic_updates = true
  resource_group_name      = data.azurerm_resource_group.ForLab-rg.name
  location                 = data.azurerm_resource_group.ForLab-rg.location
  timezone                 = var.timezone
  admin_username           = var.windows-user
  admin_password           = random_string.windowspass.result
  custom_data              = local.custom_data_content
  network_interface_ids    = [
    azurerm_network_interface.ForLab-vm-dc-nic.id,
  ]

  os_disk {
    name                 = "ForLab-vm-dc-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${random_string.windowspass.result}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.windows-user}</Username></AutoLogon>"
  }

  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = "${file("${path.module}/files/FirstLogonCommands.xml")}"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}