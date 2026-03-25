variable "prefix" {
  type        = string
  description = "Prefijo para nombrar todos los recursos (naming convention)."
}

variable "location" {
  type        = string
  description = "Región de Azure donde se despliega la infraestructura."
  default     = "eastus"
}

variable "vm_count" {
  type        = number
  description = "Número de VMs Linux en el backend pool del Load Balancer (mínimo 2)."
  default     = 2

  validation {
    condition     = var.vm_count >= 2
    error_message = "vm_count debe ser al menos 2 para alta disponibilidad."
  }
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador de las VMs Linux."
}

variable "ssh_public_key" {
  type        = string
  description = "Ruta al archivo de clave pública SSH (ej. ~/.ssh/id_ed25519.pub)."
}

variable "allow_ssh_from_cidr" {
  type        = string
  description = "CIDR desde el que se permite SSH a las VMs (ej. tu IP pública en /32)."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para todos los recursos (owner, course, env, expires)."
  default     = {}
}
