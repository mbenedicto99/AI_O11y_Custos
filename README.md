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


---

## Instalação

sudo apt update
sudo apt install -y python3-venv python3-pip unzip jq
# Terraform
sudo apt install -y terraform || { curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null \
  && sudo apt update && sudo apt install -y terraform; }
# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Databricks CLI (v0.205+)
pip install --upgrade databricks-cli

---

## 🔐 Segredos (GitHub Actions)

Em Settings → Secrets and variables → Actions, crie:

AZURE_CREDENTIALS → JSON do Service Principal (App Reg) com clientId, clientSecret, subscriptionId, tenantId.

DATABRICKS_HOST → https://adb-<id>.<region>.azuredatabricks.net

DATABRICKS_TOKEN → PAT do workspace.

