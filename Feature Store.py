# Databricks notebook source
# DBTITLE 1,LEITURA DA QUERY
table = "fs_pontos_project_churn"
#table = "fs_transacoes_project_churn"

with open(f"{table}.sql", "r") as open_file:
    query = open_file.read()

# COMMAND ----------

# DBTITLE 1,EXECUÇÃO DA QUERY
dates = [
     '2024-02-01',
     '2024-03-01',
     '2024-04-01',
     '2024-05-01',
     '2024-06-01',
     '2024-07-01',
     '2024-08-01'
]

for date in dates:
    print(date)

    # DEFINIÇÃO DA QUERY
    query_format = query.format(date=date)

    # EXECUÇÃO
    df = spark.sql(query_format)

    # DELEÇÃO DA DATA DA SAFRA QUE VAI SER INGERIDA
    try:
        spark.sql(f"DELETE FROM sandbox.med.{table} WHERE dtRef = '{date}'")
    except:
        print("Tabela ainda não existe, criando...")

    # INGESTÃO / SALVAR
    (df.write
       .mode("append")
       .format("delta")
       .option("mergeSchema", "true")
       .saveAsTable(f"sandbox.med.{table}"))

# COMMAND ----------

# DBTITLE 1,CONSULTA DA QUERY
# MAGIC %sql
# MAGIC
# MAGIC SELECT *
# MAGIC --FROM sandbox.med.fs_pontos_project_churn
# MAGIC FROM sandbox.med.fs_transacoes_project_churn
