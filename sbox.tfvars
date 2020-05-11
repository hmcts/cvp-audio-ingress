location = "uksouth"
env      = "sbox"
product  = "cvp"
common_tags = {
  environment = "sbox"
  teamName    = "cvp"
  BuiltFrom   = "https://github.com/hmcts/cvp-audio-ingress"
}
dns_zone_name       = "shared-services.uk.south.sbox.hmcts.internal"
dns_resource_group  = "shared-services_sbox_network_resource_group"
address_space       = "10.50.11.0/28"