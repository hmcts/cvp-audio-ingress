#---------------------------------------------------
# Cloudconfig for Wowza VMs
#---------------------------------------------------
data "template_file" "cloudconfig" {
  template = file(var.cloud_init_file)
  vars = {
    certPassword            = random_password.certPassword.result
    storageAccountName      = module.sa.storageaccount_name
    storageAccountKey       = module.sa.storageaccount_primary_access_key
    restPassword            = md5("wowza:Wowza:${random_password.restPassword.result}")
    streamPassword          = md5("wowza:Wowza:${random_password.streamPassword.result}")
    containerName           = local.main_container_name
    logsContainerName       = local.wowza_logs_container_name
    numApplications         = var.num_applications
    managedIdentityClientId = azurerm_user_assigned_identity.mi.client_id
    certName                = "cvp-${var.env}-le-cert"
    keyVaultName            = "cvp-${var.env}-kv"
    domain                  = "cvp-recording.${local.domain_dns_prefix}.platform.hmcts.net"
    wowzaVersion            = var.wowza_version
    dynatrace_tenant        = var.dynatrace_tenant
    dynatrace_token         = try(data.azurerm_key_vault_secret.dynatrace_token[0].value, "")
  }
}

data "template_cloudinit_config" "wowza_setup" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}