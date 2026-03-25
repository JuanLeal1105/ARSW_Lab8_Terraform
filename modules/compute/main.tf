#  Network Interfaces (una por VM)
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.prefix}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

#  Virtual Machines Linux (Ubuntu 22.04 LTS)
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-vm-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1s" # ~$8/mes — suficiente para el lab

  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  # SSH por clave — sin contraseñas
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Ubuntu 22.04 LTS Gen2
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # cloud-init: instala nginx y sirve el hostname
  custom_data = base64encode(var.cloud_init)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags
}
