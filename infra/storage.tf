resource "random_string" "suf" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                            = "${replace(var.prefix, "-", "")}${random_string.suf.result}sa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_blob_public_access        = false
  enable_https_traffic_only       = true
  is_hns_enabled                  = true # ADLS Gen2
  tags                            = var.tags
}

resource "azurerm_storage_container" "cost" {
  name                  = "cost-exports"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
