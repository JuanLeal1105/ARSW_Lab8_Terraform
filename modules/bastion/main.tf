# ─────────────────────────────────────────────────────────
#  IP Pública para Azure Bastion
#  Debe ser Standard SKU y Static (requisito de Azure)
# ─────────────────────────────────────────────────────────
resource "azurerm_public_ip" "bastion" {
  name                = "${var.prefix}-bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# ─────────────────────────────────────────────────────────
#  Azure Bastion Host
#  Permite SSH/RDP desde el portal de Azure sin exponer
#  el puerto 22 a Internet. Las VMs no necesitan IP pública.
#
#  SKU: Basic — suficiente para el lab (~$0.19/hora)
#  Destruir al terminar para evitar costos.
# ─────────────────────────────────────────────────────────
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.prefix}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = var.subnet_bastion_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}
