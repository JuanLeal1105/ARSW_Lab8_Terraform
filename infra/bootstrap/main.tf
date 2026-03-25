# ─────────────────────────────────────────────────────────
#  Sufijo aleatorio para garantizar nombre único global
# ─────────────────────────────────────────────────────────
resource "random_id" "suffix" {
  byte_length = 4
}

# ─────────────────────────────────────────────────────────
#  Resource Group exclusivo para el Terraform state
#  (separado del RG del lab para poder destruir el lab
#   sin perder el state)
# ─────────────────────────────────────────────────────────
resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate-lab8"
  location = var.location
  tags     = var.tags
}

# ─────────────────────────────────────────────────────────
#  Storage Account — Standard LRS, cifrado en reposo
#  Nombre: sttfstate<hex8> — 3-24 chars, solo minúsculas y números
# ─────────────────────────────────────────────────────────
resource "azurerm_storage_account" "tfstate" {
  name                     = "sttfstate${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Acceso público deshabilitado — solo Terraform accede por service principal
  allow_nested_items_to_be_public = false

  # Cifrado en reposo habilitado por defecto en Azure
  # El blob lease actúa como state lock automático
  tags = var.tags
}

# ─────────────────────────────────────────────────────────
#  Container para el state file
#  Acceso: private (solo autenticados)
# ─────────────────────────────────────────────────────────
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}
