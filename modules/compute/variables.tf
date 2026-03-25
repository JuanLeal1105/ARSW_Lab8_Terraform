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
  description = "Prefijo para nombrar NICs y VMs."
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador SSH de las VMs."
}

variable "ssh_public_key" {
  type        = string
  description = "Contenido de la clave pública SSH (no la ruta, el contenido)."
}

variable "subnet_id" {
  type        = string
  description = "ID de la subnet donde se conectan las NICs."
}

variable "vm_count" {
  type        = number
  description = "Número de VMs a crear."
}

variable "cloud_init" {
  type        = string
  description = "Contenido del script cloud-init (se codifica en base64)."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para NICs y VMs."
}
