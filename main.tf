provider "azurerm" {
    version             = "~> 1.30.1"
}

module "vault" {
    source              = "./modules/recoveryVault"
}

module "vm" {
    source              = "./modules/vm"
    subnet_id           = azurerm_subnet.subnet.id
}

resource "azurerm_recovery_services_protected_vm" "vm" {
  resource_group_name   = module.vault.resource_group_name
  recovery_vault_name   = module.vault.vault_name
  source_vm_id          = module.vm.id
  backup_policy_id      = module.vault.standard_policy_id
}