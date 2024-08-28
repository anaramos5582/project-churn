-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Exploração dos Dados Brutos

-- COMMAND ----------

-- DBTITLE 1,Importação das Bibliotecas
-- MAGIC %python
-- MAGIC # Importando as bibliotecas
-- MAGIC
-- MAGIC # Manipulação de dados
-- MAGIC import pandas as pd
-- MAGIC import numpy as np
-- MAGIC from datetime import date
-- MAGIC
-- MAGIC # Gráficos
-- MAGIC import matplotlib.pyplot as plt
-- MAGIC import seaborn as sns
-- MAGIC
-- MAGIC # Carregando os dados brutos
-- MAGIC df_transacoes = spark.table("silver.upsell.transacoes").toPandas()
-- MAGIC df_transacoes = df_transacoes.loc[df_transacoes['idCliente'] != '5f8fcbe0-6014-43f8-8b83-38cf2f4887b3'] #outlier (bot) indicado como premissa da base
-- MAGIC df_transacoes.head()
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df_transacoes.info()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Verificando valores únicos de cada coluna
-- MAGIC # Caso a lista de valores únicos da referida coluna seja <= 30 imprime a lista, caso contrário imprime o quantitativo de valores.
-- MAGIC
-- MAGIC def func_unique_values(df):
-- MAGIC     for col in list(df.columns):
-- MAGIC         values = df[col].unique()
-- MAGIC
-- MAGIC         if len(values) <= 30:
-- MAGIC             print("\n" + col + ': ' + str(len(values)) + ' valor(es) único(s).')
-- MAGIC             print(values)
-- MAGIC         else:
-- MAGIC             print("\n" + col + ': ' + str(len(values)) + ' valor(es) único(s).')
-- MAGIC
-- MAGIC func_unique_values(df_transacoes)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Verificando se existem valores nulos no identificador do cliente
-- MAGIC df_transacoes.idCliente.isnull().sum()
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC _ = df_transacoes.hist(bins=50,figsize=(8,5))

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Convertendo a coluna para datetime
-- MAGIC df_transacoes['dtTransacao'] = pd.to_datetime(df_transacoes['dtTransacao'])
-- MAGIC
-- MAGIC # Analisando as transações por mês
-- MAGIC df_transacoes['Mes'] = df_transacoes.dtTransacao.dt.month
-- MAGIC display(df_transacoes)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Criando a coHort de cada usuário que se inicia na mês que ele realizou a primeira transação
-- MAGIC df_transacoes['coHort']=df_transacoes.groupby('idCliente')['dtTransacao'].transform('min').dt.month
-- MAGIC display(df_transacoes)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Identificando quantos usuários aparecerem em cada coHort e quantos deles se mantém nos meses seguintes
-- MAGIC df_cohort = df_transacoes.groupby(['coHort', 'Mes']).agg(nrUsuarios=('idCliente', 'nunique')).reset_index(drop=False)
-- MAGIC df_cohort.head(10)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Sequenciando cada período/mês após o início da cohort
-- MAGIC df_cohort['periodo']=(df_cohort['Mes'] - df_cohort['coHort']).abs()
-- MAGIC df_cohort.head(30)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df_cohort_pivot = df_cohort.pivot_table(index='coHort', columns='periodo', values='nrUsuarios')
-- MAGIC df_cohort_pivot

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Localizando o tamanho de cada coHort para ser aplicado na divisão para calcular os valores em percentual
-- MAGIC df_cohort_total = df_cohort_pivot.iloc[:,0]
-- MAGIC df_cohort_total

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df_cohort_total.sum()

-- COMMAND ----------

SELECT COUNT(DISTINCT idCliente) FROM silver.upsell.transacoes;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Criando a matrix de retenção de usuários
-- MAGIC
-- MAGIC matrix_retencao = df_cohort_pivot.divide(df_cohort_total, axis=0)
-- MAGIC matrix_retencao.head()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC _ = plt.subplots(figsize=(12,7))
-- MAGIC
-- MAGIC ax = sns.heatmap(matrix_retencao, annot=True, mask=matrix_retencao.isnull(), fmt='.0%', cmap="YlGnBu")
-- MAGIC
-- MAGIC meses_x = ['Total','Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 
-- MAGIC          'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
-- MAGIC
-- MAGIC meses_y = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 
-- MAGIC          'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
-- MAGIC
-- MAGIC meses_ticks_x = [meses_x[i] for i in range(len(matrix_retencao.columns))]
-- MAGIC ax.set_xticklabels(meses_ticks_x)
-- MAGIC
-- MAGIC meses_ticks_y = [meses_y[i] for i in range(len(matrix_retencao.columns))]
-- MAGIC ax.set_yticklabels(meses_ticks_y)
-- MAGIC
-- MAGIC _ = plt.title('Matriz de Retenção de Usuários do Canal TeoMeWhy')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####**Tabela Transação Produtos**

-- COMMAND ----------

SELECT t1.descNomeProduto,
       COUNT(t1.descNomeProduto) as qtdeOcorrencia
FROM silver.upsell.transacao_produto AS t1
LEFT JOIN silver.upsell.transacoes AS t2
ON t1.idTransacao = t2.idTransacao
WHERE t2.idCliente <> "5f8fcbe0-6014-43f8-8b83-38cf2f4887b3" -- Bot indicado como premissa da base
GROUP BY ALL
ORDER BY qtdeOcorrencia DESC

--Aqui, conseguimos identificar os produtos mais frequentes

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####**Tabela Clientes**

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #Importando a tabela clientes
-- MAGIC df_cliente = spark.table("silver.upsell.cliente").toPandas()
-- MAGIC df_cliente.head()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #verificando  as estatísticas básicas
-- MAGIC df_cliente.describe().T

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #Análise de missing
-- MAGIC df_cliente.isna().sum()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #distribuição do numero de pontos por cliente
-- MAGIC df_cliente = df_cliente.loc[df_cliente['idCliente'] != '5f8fcbe0-6014-43f8-8b83-38cf2f4887b3'] #outlier (bot)
-- MAGIC
-- MAGIC sns.boxplot(data=df_cliente, y=df_cliente['nrPontosCliente'])
-- MAGIC plt.title("Distribuição de pontos por cliente", loc="center", fontsize=14)
-- MAGIC plt.xlabel("Clientes")
-- MAGIC plt.ylabel("Número de pontos")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####**Tabela Transações**

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #Importando a tabela transações
-- MAGIC df_transacoes = df_transacoes.loc[df_transacoes['idCliente'] != '5f8fcbe0-6014-43f8-8b83-38cf2f4887b3'] #outlier (bot)
-- MAGIC df_transacoes.head()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #verificando as estatísticas básicas
-- MAGIC df_transacoes.describe().T

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #Análise de missing
-- MAGIC df_transacoes.isna().sum()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #verificando as transações dias da semana
-- MAGIC df_transacoes['dtTransacao'] = pd.to_datetime(df_transacoes['dtTransacao'])
-- MAGIC df_transacoes['dia_semana'] = df_transacoes['dtTransacao'].dt.weekday
-- MAGIC
-- MAGIC df_transacoes_grouped = df_transacoes.groupby('dia_semana')['idTransacao'].nunique()
-- MAGIC
-- MAGIC fig, ax = plt.subplots(figsize=(10, 5), dpi=72)
-- MAGIC ax.spines['right'].set_visible(False)
-- MAGIC ax.spines['top'].set_visible(False)
-- MAGIC
-- MAGIC ax.bar(df_transacoes_grouped.index, df_transacoes_grouped.values)
-- MAGIC ax.set_xticks([0, 1, 2, 3, 4, 5, 6])
-- MAGIC ax.set_xticklabels(['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'])
-- MAGIC             
-- MAGIC ax.set_ylabel('Qtde de Transações')
-- MAGIC ax.set_title('Quantidade de transações por dia da semana')
-- MAGIC
-- MAGIC plt.show()
-- MAGIC
-- MAGIC print("A distribuição de transações nos dias da semana é quase uniforme e bem consistente, com um aumento de transações na sexta-feira.")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #verificando as transações por mês
-- MAGIC fig, ax = plt.subplots(figsize=(10, 5), dpi=72)
-- MAGIC ax.spines['right'].set_visible(False)
-- MAGIC ax.spines['top'].set_visible(False)
-- MAGIC
-- MAGIC df_transacoes_grouped = df_transacoes.groupby('Mes')['idTransacao'].nunique()
-- MAGIC ax.bar(df_transacoes_grouped.index, df_transacoes_grouped.values)
-- MAGIC meses = ['','Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 
-- MAGIC          'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
-- MAGIC
-- MAGIC ax.set_xticks(ticks=range(len(meses)), labels=meses)
-- MAGIC ax.set_ylabel('Qtde de Transações')
-- MAGIC ax.set_title('Quantidade de transações por Mês')
-- MAGIC
-- MAGIC plt.show()
-- MAGIC
-- MAGIC print("A distribuição de transações por mês é quase uniforme e bem consistente, com um aumento de transações nos meses de março e abril.")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC fig, ax = plt.subplots(figsize=(10, 5), dpi=72)
-- MAGIC ax.spines['right'].set_visible(False)
-- MAGIC ax.spines['top'].set_visible(False)
-- MAGIC
-- MAGIC #verificando as transações por horário
-- MAGIC df_transacoes['hora_transacao'] = df_transacoes['dtTransacao'].dt.hour
-- MAGIC
-- MAGIC df_hour_grouped = df_transacoes.groupby('hora_transacao')['idTransacao'].nunique()
-- MAGIC
-- MAGIC ax.bar(df_hour_grouped.index, df_hour_grouped.values)
-- MAGIC ax.set_xticks(range(0, 24))  # Mostrando todos os rótulos em x
-- MAGIC ax.set_ylabel('Qtde de Transações')
-- MAGIC ax.set_title('Quantidade de transações por hora do dia')
-- MAGIC plt.show()
-- MAGIC
-- MAGIC print("O pico de transações ocorre entre 12 e 13h. O maior volume de transações ocorre logo após a finalização das lives do Téo.")
-- MAGIC print("Existem transações no período da noite, porém em um volume menor. Uma hipótese é que esse volume represente pessoas que trabalham durante o dia e assistem as gravações a noite.")
