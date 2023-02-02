<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.34.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.40.0 |
| <a name="provider_azurerm.secops"></a> [azurerm.secops](#provider\_azurerm.secops) | 3.40.0 |
| <a name="provider_azurerm.shared-dns-zone"></a> [azurerm.shared-dns-zone](#provider\_azurerm.shared-dns-zone) | 3.40.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ctags"></a> [ctags](#module\_ctags) | git::https://github.com/hmcts/terraform-module-common-tags.git | master |
| <a name="module_sa"></a> [sa](#module\_sa) | git::https://github.com/hmcts/cnp-module-storage-account.git | master |
| <a name="module_vm_automation"></a> [vm\_automation](#module\_vm\_automation) | git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_key_vault_access_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_lb.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.be_add_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.rtmps_lb_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.wowza_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_management_lock.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_diagnostic_setting.cvp-kv-diag-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.cvp-lb-diag-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.cvp-nic-diag-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.cvp-nsg-diag-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.cvp-sa-diag-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_interface.wowza_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.be_add_pool_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.sg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.sg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_dns_a_record.sa_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.wowza_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.cvp-auto-acct-mi-role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.mi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.vm-status-control](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_storage_blob.deployment_flag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.deployment_details](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.sn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.sg_assoc_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.mi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.certPassword](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.restPassword](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.streamPassword](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.cvp_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.dynatrace_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ssh_pub_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [template_cloudinit_config.wowza_setup](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloudconfig](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) VNET and subnet address space [CIDR]. | `string` | n/a | yes |
| <a name="input_admin_ssh_key_path"></a> [admin\_ssh\_key\_path](#input\_admin\_ssh\_key\_path) | Path to Wowza SSH key. Defaults to "~/.ssh/wowza.pub". | `string` | `"~/.ssh/wowza.pub"` | no |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | Admin username for wowza VM(s). Defaults to admin. | `string` | `"wowza"` | no |
| <a name="input_automation_account_sku_name"></a> [automation\_account\_sku\_name](#input\_automation\_account\_sku\_name) | Azure Automation Account SKU name. | `string` | `"Basic"` | no |
| <a name="input_builtFrom"></a> [builtFrom](#input\_builtFrom) | (Required) Build pipeline. | `string` | n/a | yes |
| <a name="input_cloud_init_file"></a> [cloud\_init\_file](#input\_cloud\_init\_file) | The location of the cloud init configuration file. Defaults to "./cloudconfig.tpl". | `string` | `"./terraform/cloudconfig/cloudconfig.tpl"` | no |
| <a name="input_dev_source_address_prefixes"></a> [dev\_source\_address\_prefixes](#input\_dev\_source\_address\_prefixes) | n/a | `string` | n/a | yes |
| <a name="input_dns_resource_group"></a> [dns\_resource\_group](#input\_dns\_resource\_group) | (Required) Private DNS resource group name. | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | (Required) Private DNS zone name. | `string` | n/a | yes |
| <a name="input_dynatrace_tenant"></a> [dynatrace\_tenant](#input\_dynatrace\_tenant) | Name Given To Dynatrace Tenant. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) The platform environment. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The platform environment. Used as tag value. | `string` | n/a | yes |
| <a name="input_lb_IPaddress"></a> [lb\_IPaddress](#input\_lb\_IPaddress) | (Required) frontend IP address to use for the internal load balancer. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The azure resource location. | `string` | n/a | yes |
| <a name="input_num_applications"></a> [num\_applications](#input\_num\_applications) | Number of Wowza applications to create as part of cloudinit, defaults to 1. | `number` | `1` | no |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | OS disk size for Wowza VM(S). Defaults to 1024. | `number` | `1024` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | OS disk type for Wowza VM(s). Defaults to "Premium\_LRS". | `string` | `"Premium_LRS"` | no |
| <a name="input_product"></a> [product](#input\_product) | (Required) Product name used in naming standards. | `string` | n/a | yes |
| <a name="input_rtmps_source_address_prefixes"></a> [rtmps\_source\_address\_prefixes](#input\_rtmps\_source\_address\_prefixes) | Real-Time Messaging Protocol source IP addresses. | `list(string)` | n/a | yes |
| <a name="input_sa_access_tier"></a> [sa\_access\_tier](#input\_sa\_access\_tier) | Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cold, Defaults to Cold. | `string` | `"Cool"` | no |
| <a name="input_sa_account_kind"></a> [sa\_account\_kind](#input\_sa\_account\_kind) | Defines the Kind of account. Valid options are Storage, StorageV2 and BlobStorage. Changing this forces a new resource to be created. Defaults to BlobStorage. | `string` | `"BlobStorage"` | no |
| <a name="input_sa_account_replication_type"></a> [sa\_account\_replication\_type](#input\_sa\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS. Defaults to RAGRS. | `string` | `"RAGRS"` | no |
| <a name="input_sa_account_tier"></a> [sa\_account\_tier](#input\_sa\_account\_tier) | Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created. Defaults to Standard. | `string` | `"Standard"` | no |
| <a name="input_sa_recording_retention"></a> [sa\_recording\_retention](#input\_sa\_recording\_retention) | (Required) How long to retain the recordings in blob in days. | `number` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | (Required) Start/Stop schedule for VM(s). | <pre>list(object({<br>    name      = string<br>    frequency = string<br>    interval  = number<br>    run_time  = string<br>    start_vm  = bool<br>  }))</pre> | `[]` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | (Required) Number of Wowza VMS to create. | `number` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of VM. Defaults to "Standard\_F16s\_v2". | `string` | `"Standard_F16s_v2"` | no |
| <a name="input_wowza_offer"></a> [wowza\_offer](#input\_wowza\_offer) | Offer of the VM image. Defaults to "wowzastreamingengine". | `string` | `"wowzastreamingengine"` | no |
| <a name="input_wowza_publisher"></a> [wowza\_publisher](#input\_wowza\_publisher) | Publisher of VM image. Defaults to "wowza". | `string` | `"wowza"` | no |
| <a name="input_wowza_sku"></a> [wowza\_sku](#input\_wowza\_sku) | (Required) SKU of wowza VM image. | `string` | n/a | yes |
| <a name="input_wowza_version"></a> [wowza\_version](#input\_wowza\_version) | (Required) Version of wowza VM image. | `string` | n/a | yes |
| <a name="input_ws_name"></a> [ws\_name](#input\_ws\_name) | (Required) Workspace Name. | `string` | n/a | yes |
| <a name="input_ws_rg"></a> [ws\_rg](#input\_ws\_rg) | (Required) Workspace Resource Group. | `string` | n/a | yes |
| <a name="input_ws_sub_id"></a> [ws\_sub\_id](#input\_ws\_sub\_id) | (Required) Workspace Subscription ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rest_password"></a> [rest\_password](#output\_rest\_password) | REST password |
| <a name="output_stream_password"></a> [stream\_password](#output\_stream\_password) | Stream password |
<!-- END_TF_DOCS -->