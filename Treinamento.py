# Databricks notebook source
# DBTITLE 1,Importando bibliotecas
# Importando as bibliotecas

# Manipulação de dados
import pandas as pd
import numpy as np

# Gráficos
import matplotlib.pyplot as plt
import seaborn as sns

# Estatística
import scipy.stats as stats
from scipy.stats import normaltest

# Seleção de Variáveis
import subprocess
import sys

# Pré-Processamento e Pipeline
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.feature_selection import RFE
from sklearn.model_selection import GridSearchCV
# Instalação do feature_engine se ainda não está instalado
#subprocess.check_call([sys.executable, "-m", "pip", "install", "feature_engine"])
from feature_engine.selection import DropConstantFeatures, DropCorrelatedFeatures, SmartCorrelatedSelection

# ML
from sklearn import tree
from sklearn import ensemble
from sklearn import metrics
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn import model_selection

# COMMAND ----------

# DBTITLE 1,SAMPLE
# Carregando os dados da ABT
df_abt = spark.table("sandbox.med.abt_churn_project_churn").toPandas()
df_abt.head()

# COMMAND ----------

df_abt.info()

# COMMAND ----------

# Analisando o balanceamento da variável target
df_abt.flChurn.value_counts(normalize=True)

# COMMAND ----------

# Verificando valores únicos de cada coluna
# Caso a lista de valores únicos da referida coluna seja <= 30 imprime a lista, caso contrário imprime o quantitativo de valores.

def func_unique_values(df):
    for col in list(df.columns):
        values = df[col].unique()

        if len(values) <= 30:
            print("\n" + col + ': ' + str(len(values)) + ' valor(es) único(s).')
            print(values)
        else:
            print("\n" + col + ': ' + str(len(values)) + ' valor(es) único(s).')

func_unique_values(df_abt)

# COMMAND ----------

# DBTITLE 1,Analysis
colunas_para_excluir = ['dtRef', 'idCliente', 'flChurn','turnoMaisFrequente']
colunas_existentes = [col for col in colunas_para_excluir if col in df_abt.columns]

colunas_numericas = df_abt.select_dtypes(include=['float64', 'int64', 'int32']).drop(columns=colunas_existentes, errors='ignore').columns.tolist()

# Criando subplots
fig, axes = plt.subplots(nrows=32, ncols=2, figsize=(30, 80))

# Plotando histogramas e boxplots para cada variável
for i, var in enumerate(colunas_numericas):
    # Histograma
    sns.histplot(df_abt[var], bins=30, kde=True, ax=axes[i, 0])
    axes[i, 0].set_title(f'Histograma de {var}')

    # Boxplot
    sns.boxplot(x=df_abt[var], ax=axes[i, 1])
    axes[i, 1].set_title(f'Boxplot de {var}')

# Ajustando layout
plt.tight_layout()
plt.show()

# COMMAND ----------

# Considerando que as variáveis númericas seguem uma distribuição multimodal, analisaremos as correlações entre as variáveis utilizando o método # de Spearman, que é mais robusta e menos sensível a distribuições não normais e relações não lineares.

# Antes disso confirmaremos a distribuição das variáveis através de teste estatístico.

for i in colunas_numericas:
    stats, pval = normaltest(df_abt[i])

     # Checar valor-p
    if pval > 0.05:
        print(i, ': Distribuição Normal')
    else:
        print(i, ': Distribuição Não Normal')

# COMMAND ----------

colunas_para_excluir = ['dtRef', 'idCliente','turnoMaisFrequente']
colunas_existentes = [col for col in colunas_para_excluir if col in df_abt.columns]

plt.figure(figsize=(20, 17))

correlacoes = df_abt.drop(colunas_existentes,axis=1).corr(method="spearman")
sns.heatmap(correlacoes, annot=True, fmt='.2f', cmap='YlGnBu')
plt.show()

# COMMAND ----------

# MAGIC %md
# MAGIC Tabela de Referência da Correlação de Spearman:
# MAGIC
# MAGIC Valor da Correlação : Interpretação
# MAGIC
# MAGIC - 0.00 a 0.19 : Correlação muito fraca
# MAGIC - 0.20 a 0.39 : Correlação fraca
# MAGIC - 0.40 a 0.59 : Correlação média
# MAGIC - 0.60 a 0.79 : Correlação forte
# MAGIC - 0.80 a 1.00 : Correlação muito forte

# COMMAND ----------

# Filtrar correlações positivas mais fortes (acima de 0.59)
corr_positivas = correlacoes[(correlacoes > 0.59) & (correlacoes < 1.0)].stack().sort_values(ascending=False)

# Mostrar correlações positivas mais fortes
print("Correlações Positivas Mais Fortes (acima de 59%):")
print(corr_positivas)

# COMMAND ----------

#Filtrar correlações negativas mais fortes (entre -1 e -0.59)
corr_negativas = correlacoes[(correlacoes > -0.59) & (correlacoes < -1)].stack().sort_values(ascending=True)

# Mostrar correlações negativas mais fortes
print("Correlações Negativas Mais Fortes (entre -1 e -59%):")
print(corr_negativas)

# COMMAND ----------

# Análise de missing
df_abt.isnull().mean().sort_values(ascending=False)*100

# COMMAND ----------

target = 'flChurn'
features = df_abt.columns.tolist()[3:]
X = df_abt[features]
y = df_abt[target]

X_train, X_test, y_train, y_test = model_selection.train_test_split(X, y,
                                                                    test_size=0.2,
                                                                    random_state=42)

print("Taxa resposta treino:", y_train.mean())
print("Taxa resposta test:", y_test.mean())

# COMMAND ----------

# DBTITLE 1,Modify
# Pipeline de pré-processamento

colunas_numericas = X_train.select_dtypes(include=['int64', 'float64','int32','float32']).columns
colunas_categoricas = X_train.select_dtypes(include=['object']).columns

recorrenciaMax = X_train['nrAvgRecorrencia'].max()

parametros = {
    'max_depth': [None, 10, 20, 30, 50],              # Profundidade máxima das árvores
    'min_samples_split': [2, 5, 10],                  # Mínimo de amostras necessárias para dividir um nó
    'min_samples_leaf': [1, 2, 4],                    # Mínimo de amostras necessárias para ser uma folha
}

grid = model_selection.GridSearchCV(estimator=RandomForestClassifier(),
                                    param_grid=parametros
                                    )

preprocessor = ColumnTransformer(
    transformers=[
        ('num', Pipeline(steps=[
            ('imputer', SimpleImputer(strategy='constant', fill_value=recorrenciaMax)),
            ('scaler', StandardScaler())
        ]), colunas_numericas),
        ('cat', Pipeline(steps=[
            ('imputer', SimpleImputer(strategy='most_frequent')),
            ('encoder', OneHotEncoder(handle_unknown='ignore'))
        ]), colunas_categoricas)
    ])

# Pipeline de seleção de características
feature_selector = Pipeline(steps=[
    ('drop_constant', DropConstantFeatures(tol=0.98)),
    ('drop_correlated', DropCorrelatedFeatures(method='spearman',threshold=0.9))
])

model_pipeline = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('feature_selector', feature_selector),
    ('feature_elimination', RFE(estimator=LogisticRegression(max_iter=12000))),
    ('classifier', grid)
])

model_pipeline.fit(X_train, y_train)

# COMMAND ----------

melhores_parametros = grid.best_params_
melhor_resultado = grid.best_score_
print(melhores_parametros)
print(melhor_resultado)

# COMMAND ----------

y_predito_train = model_pipeline.predict(X_train)
acc_train = metrics.accuracy_score(y_train, y_predito_train)
print("Acurácia Treino:", acc_train)

y_predito_test = model_pipeline.predict(X_test)
acc_test  = metrics.accuracy_score(y_test, y_predito_test)
print('Acurácia Teste:', acc_test)

# COMMAND ----------

# Reports
print('------------------------TREINO------------------------')
print(metrics.classification_report(y_train, y_predito_train))
print('------------------------TESTE------------------------')
print(metrics.classification_report(y_test, y_predito_test))

# COMMAND ----------

plt.figure(figsize=(8, 5))
sns.heatmap(metrics.confusion_matrix(y_test, y_predito_test),cmap="YlGnBu", fmt='d', annot=True)
plt.xlabel('Classe Predita')
plt.ylabel('Classe Real')
plt.title('Matrix de Confusão')
plt.show()

# COMMAND ----------

# DBTITLE 1,Avaliação Curva ROC
y_proba_train = model_pipeline.predict_proba(X_train)
y_proba_train_churn = y_proba_train[:,1]

auc_train = metrics.roc_auc_score(y_train, y_proba_train_churn)
print("AUC Treino:", auc_train)

fpr_train, tpr_train, _ = metrics.roc_curve(y_train, y_proba_train_churn)

y_proba_test = model_pipeline.predict_proba(X_test)
y_proba_test_churn = y_proba_test[:,1]

auc_test = metrics.roc_auc_score(y_test, y_proba_test_churn)
print("AUC Test:", auc_test)

fpr_test, tpr_test, _ = metrics.roc_curve(y_test, y_proba_test_churn)

plt.plot(fpr_train, tpr_train, color='green')
plt.plot(fpr_test, tpr_test, color='blue')
plt.plot([0,1], [0,1], '--', color='black')
plt.grid()
plt.legend([f"Base Treino: {auc_train:.4f}", f"Base Teste: {auc_test:.4f}"])
plt.show()


y_proba_train = model_pipeline.predict_proba(X_train)
y_proba_train_churn = y_proba_train[:,1]

auc_train = metrics.roc_auc_score(y_train, y_proba_train_churn)
print("AUC Treino:", auc_train)

fpr_train, tpr_train, _ = metrics.roc_curve(y_train, y_proba_train_churn)

y_proba_test = model_pipeline.predict_proba(X_test)
y_proba_test_churn = y_proba_test[:,1]


# COMMAND ----------

modelo_ml = pd.Series({"modelo": model_pipeline})
modelo_ml.to_pickle("modelo.pkl")
