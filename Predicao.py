# Databricks notebook source
# DBTITLE 1,IMPORT DO MODELO
import pandas as pd

modelo = pd.read_pickle("modelo.pkl")

# COMMAND ----------

# DBTITLE 1,IMPORT DOS DADOS
query = """
SELECT 
       t3.dtRef,
       t3.idCliente,
       t3.nrSomaPontos,
       t3.nrSomaPontosPos,
       t3.nrSomaPontosNeg,
       t3.nrTicketMedio,
       t3.nrTicketMedioPos,
       t3.nrTicketMedioNeg,
       t3.nrPontosDia,
       t2.nrQtdeTransacoes,
       t2.nrQtdeDias,
       t2.nrRecenciaDias,
       t2.nrQtdeTransacaoDay2,
       t2.nrQtdeTransacaoDay3,
       t2.nrQtdeTransacaoDay4,
       t2.nrQtdeTransacaoDay5,
       t2.nrQtdeTransacaoDay6,
       t2.nrQtdeDay2,
       t2.nrQtdeDay3,
       t2.nrQtdeDay4,
       t2.nrQtdeDay5,
       t2.nrQtdeDay6,
       t2.nrAvgRecorrencia,
       t2.varProdutosAcessados,
       t2.qtdeProdChatMessage,
       t2.qtdeProdListaPresenca,
       t2.qtdeProdChurn5pp,
       t2.qtdeProdPresencaStreak,
       t2.qtdeProdResgatarPonei,
       t2.qtdeProdTrocaPontosStreamElements,
       t2.qtdeProdChurn10pp,
       t2.qtdeProdDailyLoot,
       t2.qtdeProdChurn2pp,
       t2.qtdeProdAirflowLover,
       t2.turnoMaisFrequente

FROM sandbox.med.fs_transacoes_project_churn AS t2

LEFT JOIN sandbox.med.fs_pontos_project_churn AS t3
ON t2.idCliente = t3.idCliente
AND t2.dtRef = t3.dtRef

WHERE t3.idCliente <> "5f8fcbe0-6014-43f8-8b83-38cf2f4887b3" 
AND t3.dtRef = (select max(dtRef) FROM sandbox.med.fs_pontos_project_churn)
"""

df_dados = spark.sql(query).toPandas()
df_dados

# COMMAND ----------

model = modelo["modelo"]
features = model.feature_names_in_

df_dados["proba_churn"] = model.predict_proba(df_dados[features])[:,1]
df_dados[['idCliente', 'proba_churn']].sort_values(by="proba_churn")
