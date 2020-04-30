location = "uksouth"
env = "sbox"
product = "cvp"
common_tags: {
  environment = "sbox"
  teamName = "cvp"
  BuiltFrom = "https://github.com/hmcts/cvp-audio-ingress"
}
service_certificate_kv_url = "foo"
service_certificate_thumbprint = "foo"
key_vault_id = "foo"
dns_zone_name = "shared-services.uk.south.sbox.hmcts.internal"
dns_resource_group = "shared-services_sbox_network_resource_group"
dns_tenant_id = "oops"
dns_client_id = "dummy"
dns_client_secret = "data"
dns_subscription_id = "a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"
workspace_to_address_space_map: {sbox = "10.50.11.0/28"}