resource "azurerm_resource_group" "rg" {
  name     = "capgemini-recovery-vault"
  location = "West Europe"
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "${var.name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "Standard"
}

resource "azurerm_recovery_services_protection_policy_vm" "standard" {
  name                = "capgemini-recovery-vault-policy"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.vault.name}"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = [ "Sunday" ]
  }

  retention_monthly {
    count    = 13
    weekdays = [ "Sunday" ]
    weeks    = [ "Last" ]
  }

  retention_yearly {
    count    = 3
    weekdays = [ "Sunday" ]
    weeks    = [ "Last" ]
    months   = [ "January" ]
  }
}