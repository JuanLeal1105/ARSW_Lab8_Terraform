variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group."
}

variable "location" {
  type        = string
  description = "Región de Azure."
}

variable "prefix" {
  type        = string
  description = "Prefijo para nombrar recursos de monitoreo."
}

variable "lb_id" {
  type        = string
  description = "ID del Load Balancer a monitorear."
}

variable "alert_email" {
  type        = string
  description = "Email que recibe las alertas de Azure Monitor."
}

variable "budget_amount" {
  type        = number
  description = "Presupuesto mensual en USD. Alerta al 80% y 100%."
  default     = 10
}

variable "subscription_id" {
  type        = string
  description = "ID de la suscripción Azure (para el Budget scope)."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para los recursos de monitoreo."
}
