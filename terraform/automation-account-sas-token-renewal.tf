#---------------------------------------------------
# SAS token renewal runbook (via module)
#---------------------------------------------------
module "automation_runbook_sas_token_renewal" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  for_each = local.sas_tokens

  name = "rotate-sas-tokens-${each.value.storage_account}-${each.value.container}-${each.value.blob}-${each.value.permissions}"

  resource_group_name              = azurerm_resource_group.rg.name
  environment                      = var.env
  storage_account_name             = each.value.storage_account
  container_name                   = each.value.container
  blob_name                        = each.value.blob
  key_vault_name                   = data.azurerm_key_vault.cvp_kv.name
  secret_name                      = "cvp-sas-${each.value.container}-${each.value.blob}-${each.value.permissions}"
  expiry_date                      = each.value.expiry_date
  automation_account_name          = azurerm_automation_account.cvp.name
  sas_permissions                  = each.value.permissions
  bypass_kv_networking             = true
  user_assigned_identity_client_id = azurerm_user_assigned_identity.mi.principal_id

  tags = module.ctags.common_tags

  depends_on = [
    azurerm_automation_account.cvp
  ]

}
