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
  description = "Prefijo para nombrar recursos de Bastion."
}

variable "subnet_bastion_id" {
  type        = string
  description = "ID de la subnet AzureBastionSubnet (debe llamarse exactamente así)."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para los recursos de Bastion."
}
