# Criação opcional de um workspace Databricks (muitos ambientes já possuem um)
resource "azurerm_databricks_workspace" "dbw" {
  count               = var.create_databricks ? 1 : 0
  name                = "${var.prefix}-dbw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
  tags                = var.tags
}

output "databricks_workspace_url" {
  value       = try(azurerm_databricks_workspace.dbw[0].workspace_url, null)
  description = "URL do workspace Databricks (se criado)"
}
