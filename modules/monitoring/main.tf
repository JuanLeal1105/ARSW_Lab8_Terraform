# ─────────────────────────────────────────────────────────
#  Action Group — a quién notificar cuando se dispara una alerta
# ─────────────────────────────────────────────────────────
resource "azurerm_monitor_action_group" "alert_email" {
  name                = "${var.prefix}-alerts-ag"
  resource_group_name = var.resource_group_name
  short_name          = "lab8alerts"

  email_receiver {
    name          = "equipo-lab8"
    email_address = var.alert_email
  }

  tags = var.tags
}

# ─────────────────────────────────────────────────────────
#  Alerta: Health Probe fallando en el Load Balancer
#
#  Métrica: DipAvailability — porcentaje de VMs que responden
#  al health probe. Si cae por debajo del 50% durante 5 min
#  (al menos 1 de 2 VMs caída) → alerta por email.
# ─────────────────────────────────────────────────────────
resource "azurerm_monitor_metric_alert" "lb_probe_down" {
  name                = "${var.prefix}-lb-probe-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.lb_id]
  description         = "Alerta cuando el health probe del LB detecta VMs no saludables."
  severity            = 2 # Warning
  frequency           = "PT1M"  # evalúa cada 1 minuto
  window_size         = "PT5M"  # ventana de 5 minutos

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 50 # menos del 50% de VMs sanas
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_email.id
  }

  tags = var.tags
}

# ─────────────────────────────────────────────────────────
#  Budget Alert — avisa cuando el gasto se acerca al límite
#
#  Scope: Resource Group del lab (no toda la suscripción)
#  Alertas: al 80% y al 100% del presupuesto mensual
# ─────────────────────────────────────────────────────────
resource "azurerm_consumption_budget_resource_group" "lab_budget" {
  name              = "${var.prefix}-budget"
  resource_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"

  amount     = var.budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }
}
