# Automation Runbook for Application secret recycling

This module is to setup a Azure Automation Runbook to start or stop VMs in a subscription.


## Example

Below is the standard example setup

```terraform
module "vm_automation" {
  source                  = "./modules/automation-runbook-vm-shutdown"
  automation_account_name = "cvp-sbox-aa"
  location                = "uksouth"
  env                     = "sbox"
  resource_group_name     = "cvp-recordings-sbox-rg"
  vm_names                = "vm1, vm2"
  vm_resting_state_on        = false
  vm_change_status        = true
  tags                    = local.common_tags
}

```

## Requirements   

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.97.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_runbook.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |
| [azurerm_automation_job_schedule.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
| [azurerm_user_assigned_identity.cvp-automation-account-mi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_definition.virtual-machine-control](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_assignment.cvp-auto-acct-mi-role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation_account_name | Automation account name | `string` | n/a | yes |   
| location | Location | `string` | uksouth | no |  
| env | Environment | `string` | n/a | yes |  
| resource_group_name | Resource group name | `string` | n/a | yes |  
| vm_names | Virtual machine names | `string` | n/a | yes |  
| vm_resting_state_on | Desired state for VM to be in | `bool` | n/a | yes |  
| vm_change_status | Automation account name | `bool` | false | yes |  
| tags | Runbook Tags | `map(string)` | n/a | yes |

## Outputs

No outputs.