output "vnet_name" {
  description = "Nombre de la Virtual Network creada."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_web_id" {
  description = "ID de la subnet WEB (usada por el módulo compute)."
  value       = azurerm_subnet.web.id
}

output "subnet_mgmt_id" {
  description = "ID de la subnet de gestión (Bastion / acceso admin)."
  value       = azurerm_subnet.mgmt.id
}
