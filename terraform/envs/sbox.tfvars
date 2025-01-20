environment                   = "sbox"
env                           = "sbox"
vm_count                      = 1
dns_zone_name                 = "shared-services.uk.south.sbox.hmcts.internal"
dns_resource_group            = "cvp-sharedinfra-sbox"
address_space                 = "10.50.11.0/28"
lb_IPaddress                  = "10.50.11.10"
rtmps_source_address_prefixes = ["35.204.50.163", "35.204.108.36", "34.91.92.40", "34.91.75.226", "81.109.71.47"]
vpn_source_address_prefixes   = ["10.99.72.4"]
ws_name                       = "hmcts-sandbox"
ws_rg                         = "oms-automation"
num_applications              = 20
vm_size                       = "Standard_D4ds_v5"
os_disk_type                  = "StandardSSD_LRS"
os_disk_size                  = "512"
dynatrace_tenant              = "yrk32651"
expiry_days                   = 3
remaining_days                = 1
sa_recording_retention        = 90
sa_default_action             = "Allow"
retention_period              = 7
schedules = [
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "18:00:00"
    start_vm  = false
  },
]
route_table = [
  {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]
