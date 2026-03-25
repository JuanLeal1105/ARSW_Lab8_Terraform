# Este módulo usa estado LOCAL a propósito:
# no puede usar el backend remoto porque es el que lo crea.
# Ejecutar UNA SOLA VEZ antes del terraform init principal.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}
