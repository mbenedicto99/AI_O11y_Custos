# AI_O11y_Custos
Previsão e probabilidade de **desvios de orçamento** em contas Azure para apoiar **SRE + FinOps** com painel, alertas e um Copilot explicável.

## Como começar
1. Crie o repositório no GitHub com este conteúdo.
2. Em **Settings → Secrets and variables → Actions**, adicione:
   - `AZURE_CREDENTIALS` (JSON do Service Principal com role *Contributor* na subscription alvo)
   - `DATABRICKS_HOST` (ex.: `https://adb-<id>.<region>.azuredatabricks.net`)
   - `DATABRICKS_TOKEN` (PAT do workspace)
3. Ajuste `infra/main.tf` (nomes, regiões, RGs) e rode o pipeline `deploy-infra`.
4. Faça push e veja os workflows rodarem (`ci`, `deploy-infra`, `deploy-databricks`, `deploy-functions`).

### Estrutura
```text
infra/               # Terraform (ADLS Gen2, Event Grid, Log Analytics, etc.) – esqueleto
jobs/                # Definições de Jobs do Databricks (JSON)
notebooks/           # Notebooks .py (treino/EDA)
src/ai_o11y_custos/  # Lib Python + Function de scoring (Azure Functions Timer)
.github/workflows/   # CI/CD (GitHub Actions)
```

### Local (dev)
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python -c "import ai_o11y_custos as m; print('ok', m.__version__)"
```
