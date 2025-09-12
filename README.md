# AI_O11y_Custos

Previsão e probabilidade de **desvios de orçamento** em contas **Azure** para apoiar **SRE + FinOps**, com automação de implantação (IaC/CI-CD), jobs de treinamento/scoring e funções agendadas para publicar sinais de risco/telemetria.

---

## 🔎 Visão geral

Este projeto entrega um pipeline de *cost analytics + ML* para detectar tendências anômalas e risco de *budget overrun* em ambientes Azure.  
Infra é criada via **Terraform**, execução de modelos via **Databricks Jobs** e **Azure Functions (Timer)** realiza *scoring* periódico e publicação em *observability backends* (ex.: Log Analytics).

---

## Estrutura
infra/               # Terraform (ADLS Gen2, Event Grid, Log Analytics, etc.)
jobs/                # Definições de Jobs do Databricks (JSON)
notebooks/           # Notebooks .py (treino/EDA)
src/ai_o11y_custos/  # Lib Python + Azure Functions (Timer) para scoring
.github/workflows/   # Pipelines CI/CD (Actions)

---

## 🏗️ Arquitetura

```mermaid
flowchart LR
  %% Dev & CI/CD
  Dev[Dev] -->|git push| GA[GitHub Actions\nCI/CD]
  GA --> TF[Terraform CLI]

  %% Azure Resource Group
  TF --> RG[Azure Subscription / RG]
  subgraph RG
    ADLS[Azure Data Lake Gen2]
    LAW[Log Analytics Workspace]
    EGW[Event Grid]
    DBW[Azure Databricks\nWorkspace]
    AFN[Azure Functions\nTimer Trigger]
  end

  %% Fluxo de dados e ML
  ADLS <-. custos/export .-> SRC[Dados de custos do Azure]
  DBW <-- Jobs (treino/featurização) --> ADLS
  AFN -->|Leitura de features| ADLS
  AFN -->|Predições/risco| LAW
  LAW -. opcional .-> EGW
  EGW -. webhooks/integrações .-> ALERT[Alertas]

  click ADLS "https://learn.microsoft.com/azure/storage/blobs/data-lake-storage-introduction" _blank
  click LAW "https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview" _blank
  click DBW "https://learn.microsoft.com/azure/databricks/" _blank
  click AFN "https://learn.microsoft.com/azure/azure-functions/functions-overview" _blank
  click EGW "https://learn.microsoft.com/azure/event-grid/overview" _blank

