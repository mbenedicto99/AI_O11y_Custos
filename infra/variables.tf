variable "prefix" {
  description = "Prefixo curto para nomear recursos"
  type        = string
  default     = "aio11y"
}

variable "location" {
  description = "Região Azure"
  type        = string
  default     = "brazilsouth"
}

variable "tags" {
  description = "Tags padrão"
  type        = map(string)
  default = {
    project = "AI_O11y_Custos"
    owner   = "FinOps-SRE"
  }
}

variable "create_databricks" {
  description = "Cria workspace Databricks (opcional)"
  type        = bool
  default     = false
}

variable "create_cost_export" {
  description = "Cria Export diário do Cost Management (requer permissões)"
  type        = bool
  default     = false
}

variable "enable_function_diagnostics" {
  description = "Ativa diagnósticos do Function App para Log Analytics"
  type        = bool
  default     = false
}
