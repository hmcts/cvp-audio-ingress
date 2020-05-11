location = "uksouth"
env      = "prod"
product  = "cvp"
common_tags = {
  environment = "prod"
  teamName    = "cvp"
  BuiltFrom   = "https://github.com/hmcts/cvp-audio-ingress"
}
dns_zone_name      = "shared-services.uk.south.prod.hmcts.internal"
dns_resource_group = "shared-services_prod_network_resource_group"
address_space      = "10.50.11.48/28"