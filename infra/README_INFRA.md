# Infraestrutura - AI_O11y_Custos (Terraform)

## O que este IaC cria
- Resource Group
- Storage Account (ADLS Gen2) + Container `cost-exports`
- Log Analytics Workspace + Application Insights (workspace-based)
- Service Plan (Linux, Consumption) + Function App (Python 3.11) com identidade gerenciada
- RBAC: Function -> Storage Blob Data Reader
- Diagnósticos do Storage para Log Analytics
- (Opcional) Workspace Databricks
- (Opcional) Export Diário do Cost Management para o ADLS

## Como aplicar
```bash
cd infra
terraform init
terraform apply -auto-approve
```

### Opções úteis
- Criar Databricks: `-var="create_databricks=true"`
- Criar Export de Custos: `-var="create_cost_export=true"`
- Ativar diagnostics da Function: `-var="enable_function_diagnostics=true"`

Exemplo completo:
```bash
terraform apply -auto-approve       -var="prefix=aio11y"       -var="location=brazilsouth"       -var="create_cost_export=true"       -var="enable_function_diagnostics=true"
```

> Dica: o workflow GitHub Actions `.github/workflows/deploy-infra.yml` já roda `terraform init/validate/apply` automaticamente ao modificar arquivos em `infra/**`.
