environment                   = "sbox"
env                           = "sbox"
dns_zone_name                 = "shared-services.uk.south.sbox.hmcts.internal"
dns_resource_group            = "cvp-sharedinfra-sbox"
address_space                 = "10.50.11.0/28"
lb_IPaddress                  = "10.50.11.10"
rtmps_source_address_prefixes = ["35.204.50.163", "35.204.108.36", "34.91.92.40", "34.91.75.226", "81.109.71.47"]
ws_name                       = "hmcts-sandbox"
ws_rg                         = "oms-automation"
num_applications              = 20
script_name                   = "" #"/vm-start-stop.ps1" # "/.terraform/modules/vm_automation/vm-start-stop.ps1"
azdo_pipe_to_change_vm_status = true
auto_acc_runbooks = [
  {
    name        = "vm_start",
    frequency   = "Day"
    interval    = 1
    start_time  = "2020-03-05T19:00:00Z"
    vm_state_on = true
  },
  {
    name        = "vm_off",
    frequency   = "Day"
    interval    = 1
    start_time  = "2020-03-05T19:00:00Z"
    vm_state_on = false
  }
]