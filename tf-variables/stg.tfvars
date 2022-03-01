environment                   = "stg"
env                           = "stg"
dns_zone_name                 = "shared-services.uk.south.stg.hmcts.internal"
dns_resource_group            = "shared-services_stg_network_resource_group"
address_space                 = "10.50.11.32/28"
lb_IPaddress                  = "10.50.11.41"
rtmps_source_address_prefixes = ["10.11.72.32/27", "10.49.72.32/27"]
ws_name                       = "hmcts-nonprod"
ws_rg                         = "oms-automation"
num_applications              = 3500
script_name                   = "./modules/automation-runbook-vm-shutdown/vm-start-stop.ps1"
# vm_status = {
#   "vm_resting_state_on" = false
#   "auto_acc_change_vm_status"    = true
# }
# runbook_schedule_times = {
#   "frequency"  = "Day"
#   "interval"   = 1
#   "timezone"   = "Europe/London"
#   "start_time" = "2022-03-01T16:00:00Z"
# }
