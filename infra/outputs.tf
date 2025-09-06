output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_container_cost_exports" {
  value = azurerm_storage_container.cost.name
}

output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "application_insights_connection_string" {
  value = azurerm_application_insights.appi.connection_string
}
