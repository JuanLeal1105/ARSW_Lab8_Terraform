output "vm_names" {
  description = "Nombres de todas las VMs creadas."
  value       = [for v in azurerm_linux_virtual_machine.vm : v.name]
}

output "nic_ids" {
  description = "IDs de las NICs (usados por el módulo lb para el backend pool)."
  value       = [for n in azurerm_network_interface.nic : n.id]
}
