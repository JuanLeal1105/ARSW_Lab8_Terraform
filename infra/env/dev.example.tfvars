prefix              = "lab8"
location            = "eastus2"
vm_count            = 2
admin_username      = "student"
ssh_public_key      = "CONTENIDO_DE_~/.ssh/id_ed25519.pub"
allow_ssh_from_cidr = "X.X.X.X/32"
subscription_id     = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
alert_email         = "tu@correo.com"
budget_amount       = 10

tags = {
  owner   = "usuario-eci"
  course  = "ARSW"
  env     = "dev"
  expires = "2026-06-30"
}