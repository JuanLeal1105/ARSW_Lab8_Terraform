output "lb_public_ip" {
  description = "IP pública del Load Balancer. Úsala para validar con: curl http://<ip>"
  value       = module.lb.public_ip
}

output "resource_group_name" {
  description = "Nombre del Resource Group desplegado."
  value       = azurerm_resource_group.rg.name
}

output "vm_names" {
  description = "Lista de nombres de las VMs en el backend pool."
  value       = module.compute.vm_names
}

#  Retos 
output "bastion_name" {
  description = "Nombre del Azure Bastion Host."
  value       = module.bastion.bastion_name
}

output "bastion_dns" {
  description = "DNS del Bastion para conectarse desde el portal de Azure."
  value       = module.bastion.bastion_dns_name
}
