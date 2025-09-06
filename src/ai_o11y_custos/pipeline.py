from __future__ import annotations
import numpy as np
import pandas as pd
from sklearn.ensemble import IsolationForest
from typing import Dict

def prob_overrun(df_scope: pd.DataFrame, budget: float) -> float:
    """
    df_scope: DataFrame com colunas ['date','spend'] (uma linha por dia do mês corrente).
    budget: orçamento total do mês para o escopo.
    """
    df = df_scope.copy()
    df['date'] = pd.to_datetime(df['date'])
    df = df.sort_values('date').set_index('date').asfreq('D').fillna(0.0)

    daily = df['spend']
    if len(daily) < 7:
        runrate = daily.mean()
    else:
        runrate = daily.rolling(7).mean().iloc[-1]

    today = daily.index[-1]
    month_end = today.to_period('M').end_time.normalize()
    days_left = (month_end - today).days

    hist_err = (daily - daily.rolling(7).mean()).dropna().values
    if hist_err.size == 0:
        hist_err = np.array([0.0])

    sims = []
    for _ in range(1000):
        noise = np.random.choice(hist_err, size=max(days_left, 0), replace=True)
        sims.append(daily.sum() + (runrate + (noise.mean() if days_left else 0))*days_left)
    sims = np.array(sims) if sims else np.array([daily.sum()])

    return float((sims > budget).mean())

def anomaly_score(df_scope: pd.DataFrame) -> float:
    X = df_scope[['spend']].values
    iso = IsolationForest(contamination=0.02, random_state=0).fit(X)
    return float(-iso.score_samples([X[-1]])[0])

def risk_score(df_scope: pd.DataFrame, budget: float) -> Dict[str, float]:
    p = prob_overrun(df_scope, budget)
    a = anomaly_score(df_scope)
    score = min(100.0, 100.0 * p * (1.0 + min(a, 3.0)/5.0))
    return {"prob_overrun": p, "anomaly": a, "risk_score": score}
