# Arquitetura — AI_O11y_Custos

```mermaid
flowchart LR
  subgraph A[Fontes & Governança]
    CM[Cost Management Exports (CSV)]
    PS[PriceSheet/RateCard]
    BG[Budgets & Alerts]
    ADV[Advisor / RIs / Savings Plans]
    POL[Azure Policy (Tags)]
    MON[Azure Monitor (Métricas)]
    DD[(Opc.) Datadog/Dynatrace]
  end

  subgraph B[Dados & Orquestração]
    ADLS[ADLS Gen2 (Raw/Curated/Delta)]
    ADF[ADF/Synapse Pipelines]
    EVG[Event Grid (arquivo novo)]
  end

  subgraph C[Modelos & MLOps]
    DBX[Databricks / Azure ML (Treino)]
    MLF[MLflow (metrics/models)]
    FS[Feature Store / Jobs]
    FUNC[Azure Functions (Scoring diário)]
    KV[Key Vault]
  end

  subgraph D[Observabilidade & Persistência]
    LA[Log Analytics (KQL)]
    APPi[Application Insights]
    SCORE[Scores (Storage/LA Table)]
  end

  subgraph E[Consumo & Copilot]
    BI[Power BI / Grafana (FinOps Risk Board)]
    ALERT[Azure Monitor Alerts (Teams/Email/ITSM)]
    COP[Azure OpenAI + Cognitive Search (Copilot)]
    ITSM[Tickets: Jira/ServiceNow]
  end

  subgraph CI[CI/CD — GitHub Actions]
    CI1[CI (lint/test)]
    CI2[Deploy Infra (Terraform)]
    CI3[Sync Repos + Jobs (Databricks)]
    CI4[Deploy Azure Functions]
  end

  %% Fluxos
  CM --> ADLS
  PS --> ADLS
  BG --> ADLS
  ADV --> ADLS
  POL --> ADLS
  MON --> ADLS
  DD --> ADLS

  ADLS --> ADF
  ADF --> ADLS
  ADLS --> DBX
  EVG --> FUNC
  DBX --> FUNC

  FUNC --> LA
  FUNC --> SCORE
  APPi --> LA

  LA --> BI
  LA --> ALERT
  LA --> COP
  SCORE --> BI
  ALERT --> ITSM

  KV --> DBX
  KV --> FUNC

  CI2 --> ADLS
  CI2 --> LA
  CI2 --> FUNC
  CI3 --> DBX
  CI4 --> FUNC

