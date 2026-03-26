output "action_group_id" {
  description = "ID del Action Group de alertas."
  value       = azurerm_monitor_action_group.alert_email.id
}

output "metric_alert_id" {
  description = "ID de la alerta de health probe del LB."
  value       = azurerm_monitor_metric_alert.lb_probe_down.id
}
