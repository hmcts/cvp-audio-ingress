#---------------------------------------------------
# Flex Consumption Function App for crime
#---------------------------------------------------

locals {
  function_storage_connection_string = "DefaultEndpointsProtocol=https;AccountName=${module.sa.storageaccount_name};AccountKey=${module.sa.storageaccount_primary_access_key};EndpointSuffix=core.windows.net"
}

resource "azapi_resource" "function_app_crime" {
  type      = "Microsoft.Web/sites@2024-04-01"
  name      = "${var.product}-recordings-${var.env}-facrimetest"
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi_function.id]
  }

  body = {
    kind = "functionapp,linux"
    properties = {
      serverFarmId = module.app_service_plan.asp_id
      httpsOnly    = true
      functionAppConfig = {
        deployment = {
          storage = {
            type  = "blobContainer"
            value = "https://${module.sa.storageaccount_name}.blob.core.windows.net/recordings01"
            authentication = {
              type                               = "StorageAccountConnectionString"
              storageAccountConnectionStringName = "DEPLOYMENT_STORAGE_CONNECTION_STRING"
            }
          }
        }
        scaleAndConcurrency = {
          instanceMemoryMB     = 2048
          maximumInstanceCount = 100
        }
        runtime = {
          name    = "dotnet-isolated"
          version = "10.0"
        }
      }
      siteConfig = {
        appSettings = [
          {
            name  = "AzureWebJobsStorage"
            value = local.function_storage_connection_string
          },
          {
            name  = "DEPLOYMENT_STORAGE_CONNECTION_STRING"
            value = local.function_storage_connection_string
          },
          {
            name  = "AZURE_CLIENT_ID"
            value = azurerm_user_assigned_identity.mi_function.client_id
          },
          {
            name  = "RECORDING_DRY_RUN"
            value = "false"
          }
        ]
      }
    }
  }

  tags = module.ctags.common_tags
}