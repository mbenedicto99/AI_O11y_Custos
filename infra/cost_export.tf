# Export diário do Azure Cost Management para o ADLS (opcional)
# ATENÇÃO: requer permissões específicas na assinatura para criar exports.
# Habilite com -var="create_cost_export=true"
resource "azurerm_cost_management_export" "daily" {
  count = var.create_cost_export ? 1 : 0

  name  = "${var.prefix}-cost-export"
  scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  recurrence = "Daily"

  recurrence_period {
    from = "2025-09-01T00:00:00Z"
    to   = "2030-01-01T00:00:00Z"
  }

  delivery_info {
    destination {
      resource_id        = azurerm_storage_account.sa.id
      container          = azurerm_storage_container.cost.name
      root_folder_path   = "exports"
    }
  }

  format = "Csv"
  time_period {
    type = "BillingMonthToDate"
  }
}
