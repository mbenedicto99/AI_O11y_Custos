terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "prefix" { default = "aio11y" }
variable "location" { default = "brazilsouth" }

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# TODO: ADLS Gen2, Event Grid, Log Analytics, Key Vault, Function App, Databricks/AML
