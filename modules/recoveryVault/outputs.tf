output "resource_group_name" {
  description = "Resource group name for the recovery vault"
  value       = "${azurerm_resource_group.rg.name}"
}

output "vault_name" {
  description = "Recovery vault name"
  value       = "${azurerm_recovery_services_vault.vault.name}"
}

output "vault_id" {
  description = "Recovery Vault ID"
  value       = "${azurerm_recovery_services_vault.vault.id}"
}

output "standard_policy_id" {
  description = "Protection Policy ID for standard"
  value       = "${azurerm_recovery_services_protection_policy_vm.standard.id}"
}
