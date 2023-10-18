environment                   = "stg"
env                           = "stg"
vm_count                      = 2
dns_zone_name                 = "shared-services.uk.south.stg.hmcts.internal"
dns_resource_group            = "shared-services_stg_network_resource_group"
address_space                 = "10.50.11.32/28"
lb_IPaddress                  = "10.50.11.41"
rtmps_source_address_prefixes = ["10.11.72.32/27", "10.49.72.32/27"]
vpn_source_address_prefixes   = ["10.99.19.4"]
ws_name                       = "hmcts-nonprod"
ws_rg                         = "oms-automation"
num_applications              = 3500
vm_size                       = "Standard_D8ds_v5"
dynatrace_tenant              = "yrk32651"
expiry_days                   = 10
remaining_days                = 3
schedules = [
  {
    name      = "vm-off-weekly",
    frequency = "Week"
    interval  = 1
    run_time  = "15:00:00"
    start_vm  = false
    week_days = ["Saturday"]
  },
  {
    name      = "vm-on-weekly",
    frequency = "Week"
    interval  = 1
    run_time  = "05:00:00"
    start_vm  = true
    week_days = ["Monday"]
  }
]
