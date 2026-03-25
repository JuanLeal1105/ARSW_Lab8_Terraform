variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group donde se crea la VNet."
}

variable "location" {
  type        = string
  description = "Región de Azure."
}

variable "prefix" {
  type        = string
  description = "Prefijo para nombrar los recursos de red."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas aplicadas a todos los recursos de red."
}
