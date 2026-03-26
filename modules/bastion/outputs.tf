output "bastion_name" {
  description = "Nombre del Azure Bastion Host."
  value       = azurerm_bastion_host.bastion.name
}

output "bastion_dns_name" {
  description = "DNS del Bastion para conectarse desde el portal."
  value       = azurerm_bastion_host.bastion.dns_name
}
