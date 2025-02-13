environment                   = "prod"
env                           = "prod"
vm_count                      = 2
dns_zone_name                 = "shared-services.uk.south.prod.hmcts.internal"
dns_resource_group            = "shared-services_prod_network_resource_group"
address_space                 = "10.50.11.48/28"
lb_IPaddress                  = "10.50.11.61"
rtmps_source_address_prefixes = ["35.246.64.24", "35.246.125.146", "35.246.120.206", "35.246.120.206", "35.246.26.18", "35.246.61.112", "35.197.192.122", "35.197.192.122", "35.234.156.229", "35.189.122.97", "35.189.103.174", "35.246.9.25", "35.242.188.19", "35.230.134.63", "35.234.144.216", "35.242.179.109", "35.246.20.226", "35.230.150.118", "35.197.225.12", "34.89.57.150", "34.89.47.84", "35.230.133.33", "35.189.82.242", "35.230.139.59", "35.189.65.193", "35.246.108.50", "34.89.85.40", "34.89.112.200", "34.89.24.209", "35.246.119.253", "35.246.31.7", "34.89.124.198", "35.246.44.168", "35.197.222.76", "35.246.113.78", "35.197.252.192", "34.89.16.12", "35.246.9.51", "35.234.136.134", "35.246.55.21", "35.189.100.191", "35.242.128.122", "35.230.150.72", "34.89.90.252", "34.105.172.197", "34.105.156.138", "35.197.233.103", "34.105.254.1", "35.197.226.208", "34.105.175.144", "34.105.191.88", "34.105.185.156", "34.89.20.125", "35.197.196.46", "35.189.126.139", "34.105.181.204", "34.89.39.181", "34.77.152.87", "35.189.116.218", "35.197.253.33", "35.189.94.75", "34.89.9.141", "35.246.33.64", "34.105.186.145", "34.89.124.153", "35.242.182.90", "34.105.158.61", "35.246.46.20", "35.189.114.248", "34.105.132.33", "34.105.159.151", "35.197.243.189", "35.246.78.140", "35.197.206.63", "34.105.130.201", "35.230.142.100", "34.105.148.74", "34.105.241.54", "34.105.191.37", "34.89.94.255", "35.234.154.137", "34.105.137.114", "34.89.79.120", "34.105.128.1", "35.189.76.6", "34.105.132.247", "34.105.199.202", "34.89.58.234", "34.105.220.46", "35.189.85.128", "34.89.26.193", "34.89.55.45", "35.246.83.177", "34.89.112.7", "35.246.108.205", "35.189.71.128", "35.242.169.216", "34.89.50.164", "35.246.58.8", "34.105.225.83", "34.89.47.135", "35.197.245.49", "34.89.10.36", "35.242.165.45", "35.230.154.5", "35.234.145.136", "35.234.156.166", "34.105.164.16", "34.89.47.123", "35.242.137.0", "34.89.28.171", "34.105.229.172", "34.105.180.47", "35.246.88.27", "34.105.201.194", "35.242.161.144", "34.89.67.244", "35.197.219.228", "34.105.204.202", "34.105.233.162", "35.242.138.161", "34.105.201.126", "34.89.9.21", "34.105.222.224", "34.89.42.12", "34.105.220.131", "35.189.85.234", "35.246.42.154", "81.133.255.164", "81.109.71.47"]
ws_name                       = "hmcts-prod"
ws_rg                         = "oms-automation"
num_applications              = 3500
vm_size                       = "Standard_D4ds_v5"
dynatrace_tenant              = "ebe20728"
expiry_days                   = 15
remaining_days                = 5
sa_default_action             = "Allow"
retention_period              = 30
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
sa_allowed_subnets = [
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-00",
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-01"
]

sa_allowed_ips = [
  "128.77.75.64/26",  #GlobalProtect VPN egress range
  "51.149.249.0/29",  #AnyConnect VPN egress range
  "51.149.249.32/29", #AnyConnect VPN egress range
  "194.33.249.0/29",  #AnyConnect VPN egress backup range
  "194.33.248.0/29"   #AnyConnect VPN egress backup range
]

hrs_aks_source_address_prefixes = [
  "10.90.64.0/20", # cft-prod-vnet aks-00
  "10.90.80.0/20"  # cft-prod-vnet aks-01
]