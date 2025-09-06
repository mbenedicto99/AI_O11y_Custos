# Databricks notebook (formato .py) – treino/validação simples
# Ajuste para ler do ADLS/Delta no seu workspace.
import mlflow
import pandas as pd
from ai_o11y_custos.pipeline import risk_score

mlflow.set_experiment("/Shared/AI_O11y_Custos/experiments/train")

# Exemplo mínimo: dataframe fake só para validar pipeline
dates = pd.date_range("2025-09-01", periods=5, freq="D")
df = pd.DataFrame({"date": dates, "spend": [100, 120, 95, 140, 130]})
budget = 3000.0

with mlflow.start_run():
    metrics = risk_score(df, budget)
    for k, v in metrics.items():
        mlflow.log_metric(k, float(v))

print("Treino concluído. Métricas:", metrics)
