environment                   = "stg"
env                           = "stg"
vm_count                      = 2
dns_zone_name                 = "shared-services.uk.south.stg.hmcts.internal"
dns_resource_group            = "shared-services_stg_network_resource_group"
address_space                 = "10.50.11.32/28"
lb_IPaddress                  = "10.50.11.41"
rtmps_source_address_prefixes = ["10.11.72.32/27", "10.49.72.32/27"]
vpn_source_address_prefixes   = ["10.99.72.4"]
ws_name                       = "hmcts-nonprod"
ws_rg                         = "oms-automation"
num_applications              = 3500
vm_size                       = "Standard_D4ds_v5"
os_disk_type                  = "StandardSSD_LRS"
os_disk_size                  = "512"
dynatrace_tenant              = "yrk32651"
expiry_days                   = 10
remaining_days                = 3
sa_recording_retention        = 90 # 7 years
sa_default_action             = "Allow"
retention_period              = 14
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
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  },
  {
    name                   = "soc-prod-vnet"
    address_prefix         = "10.146.0.0/21"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  }
]
