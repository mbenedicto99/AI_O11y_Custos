resource "azurerm_service_plan" "plan" {
  name                = "${var.prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1" # Consumption
  tags                = var.tags
}

resource "azurerm_linux_function_app" "func" {
  name                       = "${var.prefix}-func"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.plan.id

  # Armazenamento para conteúdos/funcionamento
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  functions_extension_version = "~4"

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
    ftps_state = "Disabled"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"         = "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"   = azurerm_application_insights.appi.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appi.connection_string

    # Ajuste conforme sua leitura de custos
    "COSTS_ACCOUNT_NAME" = azurerm_storage_account.sa.name
    "COSTS_CONTAINER"    = azurerm_storage_container.cost.name
    "COSTS_PATH_PREFIX"  = "exports/"
  }

  tags = var.tags
}

# Permissão para a Function ler blobs do Storage
resource "azurerm_role_assignment" "func_blob_reader" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_function_app.func.identity[0].principal_id
}
