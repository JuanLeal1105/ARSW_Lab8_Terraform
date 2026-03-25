prefix              = "lab8"
location            = "brazilsouth"
vm_count            = 2
admin_username      = "student"
ssh_public_key      = "~/.ssh/id_ed25519.pub"
allow_ssh_from_cidr = "0.0.0.0/0"
tags = {
  owner   = "usuario-eci"
  course  = "ARSW"
  env     = "dev"
  expires = "2026-06-30"
}