# Logs do Storage -> Log Analytics (útil para auditoria/monitoramento)
resource "azurerm_monitor_diagnostic_setting" "sa_to_law" {
  name                       = "${var.prefix}-sa-diag"
  target_resource_id         = azurerm_storage_account.sa.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# (Opcional) Logs da Function App -> Log Analytics (algumas categorias podem variar; deixe desativado se não tiver certeza)
resource "azurerm_monitor_diagnostic_setting" "func_to_law" {
  count                      = var.enable_function_diagnostics ? 1 : 0
  name                       = "${var.prefix}-func-diag"
  target_resource_id         = azurerm_linux_function_app.func.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "FunctionAppLogs"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
