#  Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

#  Módulo: Red Virtual (VNet + Subnets)
module "vnet" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  tags                = var.tags
}

#  Módulo: Cómputo (NICs + VMs Linux con cloud-init)
module "compute" {
  source              = "../modules/compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  subnet_id           = module.vnet.subnet_web_id
  vm_count            = var.vm_count
  cloud_init          = file("${path.module}/cloud-init.yaml")
  tags                = var.tags
}

#  Módulo: Load Balancer L4 + NSG
module "lb" {
  source              = "../modules/lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  backend_nic_ids     = module.compute.nic_ids
  allow_ssh_from_cidr = var.allow_ssh_from_cidr
  tags                = var.tags
}


#  Reto 1: Azure Bastion
#  SSH seguro sin exponer puerto 22 a Internet
module "bastion" {
  source              = "../modules/bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  subnet_bastion_id   = module.vnet.subnet_bastion_id
  tags                = var.tags
}

#  Reto 2: Azure Monitor + Budget Alert
#  Alerta de health probe + alerta de presupuesto
module "monitoring" {
  source              = "../modules/monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  lb_id               = module.lb.lb_id
  alert_email         = var.alert_email
  budget_amount       = var.budget_amount
  subscription_id     = var.subscription_id
  tags                = var.tags
}
