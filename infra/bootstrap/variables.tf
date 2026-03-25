variable "location" {
  type        = string
  description = "Región de Azure para el Storage Account del state."
  default     = "brazilsouth"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas aplicadas al RG y Storage Account del state."
  default = {
    owner   = "JuanK"
    course  = "ARSW"
    env     = "tfstate"
    expires = "2026-06-30"
  }
}
