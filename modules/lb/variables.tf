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
  description = "Prefijo para nombrar recursos del LB."
}

variable "backend_nic_ids" {
  type        = list(string)
  description = "Lista de IDs de NICs que forman el backend pool."
}

variable "allow_ssh_from_cidr" {
  type        = string
  description = "CIDR autorizado para SSH (puerto 22). Usa tu IP/32."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para los recursos del LB y NSG."
}
