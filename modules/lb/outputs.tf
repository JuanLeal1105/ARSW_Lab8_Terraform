output "public_ip" {
  description = "IP pública del Load Balancer para validar con curl."
  value       = azurerm_public_ip.pip.ip_address
}

output "lb_id" {
  description = "ID del Load Balancer (útil para referencias cruzadas)."
  value       = azurerm_lb.lb.id
}

output "nsg_id" {
  description = "ID del Network Security Group."
  value       = azurerm_network_security_group.nsg.id
}
