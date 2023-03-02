locals {
  service_name              = "${var.product}-recordings-${var.env}"
  domain_dns_prefix         = var.env == "stg" ? "aat" : var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
  main_container_name       = "recordings"
  wowza_logs_container_name = "wowzalogs"
  splunk_admin_username     = "splunkadmin"
  la_id                     = replace(data.azurerm_log_analytics_workspace.log_analytics.id, "resourcegroups", "resourceGroups")
  sas_tokens = {
    "recordings-rlw" = {
      permissions     = "rlw"
      storage_account = "${replace(lower(local.service_name), "-", "")}sa"
      container       = local.main_container_name
      blob            = ""
      expiry_date     = timeadd(timestamp(), "167h")
    }
    "wowzalogas-rlw" = {
      permissions     = "rlw"
      storage_account = "${replace(lower(local.service_name), "-", "")}sa"
      container       = local.wowza_logs_container_name
      blob            = ""
      expiry_date     = timeadd(timestamp(), "167h")
    }
  }
  peering_vpn_vnet          = "core-infra-vnet-mgmt"
  peering_vpn_subscription  = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  peering_vpn_resourcegroup = "rg-mgmt"
  lb-rules = {
    RTMPS = {
      protocol      = "Tcp"
      frontend_port = 443
      backend_port  = 443
    }
    WowzaManager = {
      protocol      = "Tcp"
      frontend_port = 8080
      backend_port  = 8080
    }
    WowzaAPI = {
      protocol      = "Tcp"
      frontend_port = 8087
      backend_port  = 8087
    }
  }
}
