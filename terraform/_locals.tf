locals {
  service_name              = "${var.product}-recordings-${var.env}"
  domain_dns_prefix         = var.env == "stg" ? "aat" : var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
  common_tags               = module.ctags.common_tags
  main_container_name       = "recordings"
  wowza_logs_container_name = "wowzalogs"
  la_id                     = replace(data.azurerm_log_analytics_workspace.log_analytics.id, "resourcegroups", "resourceGroups")
}