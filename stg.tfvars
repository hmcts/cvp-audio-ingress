env      = "stg"
product  = "cvp"
common_tags = {
  environment = "stg"
  teamName    = "cvp"
  BuiltFrom   = "https://github.com/hmcts/cvp-audio-ingress"
}
dns_zone_name      = "shared-services.uk.south.stg.hmcts.internal"
dns_resource_group = "shared-services_stg_network_resource_group"
address_space      = "10.50.11.32/28"