locals {
  service_name              = "${var.product}-recordings-${var.env}"
  domain_dns_prefix         = var.env == "stg" ? "aat" : var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
  main_container_name       = "recordings"
  wowza_logs_container_name = "wowzalogs"
  splunk_admin_username     = "splunkadmin"
  la_id                     = replace(data.azurerm_log_analytics_workspace.log_analytics.id, "resourcegroups", "resourceGroups")
  sas_tokens = {
    "recordings-rl" = {
        permissions     = "rl"
        storage_account = "${replace(lower(local.service_name), "-", "")}sa"
        container       = local.main_container_name
        blob            = ""
        expiry_date     = timeadd(timestamp(), "167h")
    },
    "recordings-rlw" = {
        permissions     = "rlw"
        storage_account = "${replace(lower(local.service_name), "-", "")}sa"
        container       = local.main_container_name
        blob            = ""
        expiry_date     = timeadd(timestamp(), "167h")
    }
}
}