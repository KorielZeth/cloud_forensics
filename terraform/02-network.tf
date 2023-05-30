# Récupération de l'IP publique actuelle pour du whitelisting
data "http" "public-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Création d'un réseau virtuel dans le groupe de ressources
resource "azurerm_virtual_network" "ForLab-vnet" {
  name                = "ForLab-vnet"
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  location            = data.azurerm_resource_group.ForLab-rg.location
  address_space       = ["10.0.0.0/8"]
}

# Création d'un sous-réseau dans le réseau virtuel ci-dessus
resource "azurerm_subnet" "ForLab-subnet" {
  name                 = "ForLab-subnet"
  resource_group_name  = data.azurerm_resource_group.ForLab-rg.name
  virtual_network_name = azurerm_virtual_network.ForLab-vnet.name
  address_prefixes     = ["10.99.10.0/24"]
}

# Création d'un groupe de sécurité réseau pour le sous-réseau
resource "azurerm_network_security_group" "ForLab-nsg" {
  name                = "ForLab-nsg"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = "${concat(var.ip-whitelist, ["${chomp(data.http.public-ip.body)}/32"])}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.ip-whitelist
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Internal"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.99.10.0/24"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ForLab-nsga" {
  subnet_id                 = azurerm_subnet.ForLab-subnet.id
  network_security_group_id = azurerm_network_security_group.ForLab-nsg.id
}

# Création d'une IP publique pour le lab
resource "azurerm_public_ip" "ForLab-ip" {
  name                = "ForLab-ip"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  allocation_method   = "Static"
  domain_name_label   = var.domain-name-label
  sku                 = "Standard"
}

# Création d'une autre IP publique pour le traffic sortant
resource "azurerm_public_ip" "ForLab-ip-outbound" {
  name                = "ForLab-ip-outbound"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Création d'un load balancer sur l'IP publique
resource "azurerm_lb" "ForLab-lb" {
  name                = "ForLab-lb"
  location            = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name = data.azurerm_resource_group.ForLab-rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "ForLab-lb-ip-public"
    public_ip_address_id = azurerm_public_ip.ForLab-ip.id
  }
}

resource "azurerm_lb_nat_rule" "ForLab-lb-nat-http" {
  resource_group_name            = data.azurerm_resource_group.ForLab-rg.name
  loadbalancer_id                = azurerm_lb.ForLab-lb.id
  name                           = "HTTPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ForLab-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "ForLab-lb-nat-ssh" {
  resource_group_name            = data.azurerm_resource_group.ForLab-rg.name
  loadbalancer_id                = azurerm_lb.ForLab-lb.id
  name                           = "SSHAccess"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "ForLab-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "ForLab-lb-nat-rdp" {
  resource_group_name            = data.azurerm_resource_group.ForLab-rg.name
  loadbalancer_id                = azurerm_lb.ForLab-lb.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "ForLab-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "ForLab-lb-nat-rdp2" {
  resource_group_name            = data.azurerm_resource_group.ForLab-rg.name
  loadbalancer_id                = azurerm_lb.ForLab-lb.id
  name                           = "RDPAccess2"
  protocol                       = "Tcp"
  frontend_port                  = 3390
  backend_port                   = 3389
  frontend_ip_configuration_name = "ForLab-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "ForLab-lb-nat-ssh2" {
  resource_group_name            = data.azurerm_resource_group.ForLab-rg.name
  loadbalancer_id                = azurerm_lb.ForLab-lb.id
  name                           = "SSHAccess2"
  protocol                       = "Tcp"
  frontend_port                  = 2222
  backend_port                   = 22
  frontend_ip_configuration_name = "ForLab-lb-ip-public"
}


# Création d'une gateway NAT pour le traffic sortant vers internet
resource "azurerm_nat_gateway" "ForLab-nat-gateway" {
  name                    = "ForLab-nat-gateway"
  location                = data.azurerm_resource_group.ForLab-rg.location
  resource_group_name     = data.azurerm_resource_group.ForLab-rg.name
}

resource "azurerm_nat_gateway_public_ip_association" "ForLab-nat-gateway-ip" {
  nat_gateway_id       = azurerm_nat_gateway.ForLab-nat-gateway.id
  public_ip_address_id = azurerm_public_ip.ForLab-ip-outbound.id
}

resource "azurerm_subnet_nat_gateway_association" "ForLab-nat-gateway-subnet" {
  subnet_id      = azurerm_subnet.ForLab-subnet.id
  nat_gateway_id = azurerm_nat_gateway.ForLab-nat-gateway.id
}