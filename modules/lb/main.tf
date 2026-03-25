#  IP Pública estática para el Load Balancer
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#  Azure Load Balancer L4 (Standard SKU)
resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "Public"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = var.tags
}

#  Backend Pool
resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "${var.prefix}-bepool"
  loadbalancer_id = azurerm_lb.lb.id
}

# Asocia cada NIC al backend pool
resource "azurerm_network_interface_backend_address_pool_association" "assoc" {
  count                   = length(var.backend_nic_ids)
  network_interface_id    = var.backend_nic_ids[count.index]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}

#  Health Probe (TCP/80)
#  El LB saca del pool VMs que no respondan en este puerto
resource "azurerm_lb_probe" "probe" {
  name            = "http-80"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

#  Load Balancing Rule: 80 → 80 (HTTP)
resource "azurerm_lb_rule" "rule_http" {
  name                           = "http-80"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "Public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}


#  Network Security Group (NSG)
#  Principio de mínimo privilegio:
#   - HTTP 80 desde Internet
#   - SSH 22 solo desde tu IP
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-web-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Regla 1: HTTP desde Internet (cualquier origen)
  security_rule {
    name                       = "Allow-HTTP-Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Regla 2: SSH solo desde tu IP (allow_ssh_from_cidr en /32)
  security_rule {
    name                       = "Allow-SSH-From-Home"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allow_ssh_from_cidr
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Asocia el NSG a cada NIC de las VMs
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = length(var.backend_nic_ids)
  network_interface_id      = var.backend_nic_ids[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}
