## 1. Introdução e escopo
### Objetivo do modelo

Este modelo possui como objetivo estimar a probabilidade de Churn (abandono) de um usuário no canal Téo Me Why, com base nos dados que temos no datalake.

O churn é definido como abandono do canal após um período de 28 dias sem transação.

É esperado que a utilização do modelo ajude a reduzir a taxa de churn, e por consequência aumente a movimentação na comunidade do canal TeoMeWhy.

### Histórico de versões

| Versão | Data | Responsáveis | Descrição |
| ------ | ------ | ------ | ------ |
| V1.0 | 26/08/2024 | Ana Paula Barros Ramos e Maria Fernanda O. Silvestre | Desenvolvimento do modelo de Churn de Usuários |

### Visão regulatória

No escopo do churn, não existem regulamentações que tenham impacto no tema.

### Papéis e responsabilidades

O projeto será realizado conjuntamente pelas áreas, responsáveis e ponto focal indicados abaixo.

| Papel/Atividade | Área responsável | Ponto focal |
| -------- | -------- | -------- |
| Descrição do Processo | Sistemas de ponto do Canal TeoMeWhy | Canal TeoMeWhy |
| Disponibilização dos Dados | Databricks | Canal TeoMeWhy & MeD |
| Análise Exploratória Inicial | Análise de Dados | Ana Paula e Maria Fernanda |
| Desenvolvimento do Modelo | Ciência de Dados | Ana Paula e Maria Fernanda |
| Validação da Metodologia | Validação do Modelo | Canal TeoMeWhy |

### Público alvo

O público alvo considerado para a construção do target deste modelo foi selecionado a partir das características abaixo:
* Transações de usuários realizadas nos períodos entre as seguintes datas de referência: 01/02/2024, 01/03/2024, 01/04/2024, 01/05/2024, 01/06/2024, 01/07/2024, 01/08/2024 e seus últimos 28 dias antecedentes.

### Target

A variável target do modelo é do tipo binária e será construída avaliando as transações realizadas pelos usuários na respectiva data de referência.
Churn: usuário abandona o canal em até 28 dias após a data de referência.
Não Churn: caso contrário.

### Bases de dados utilizadas

As bases de dados utilizadas com as respectivas informações são apresentadas na tabela abaixo:

| Base de dados | Datas base de referência | Quantidade de observações | Fonte de informação | Responsável pela disponibilização |
| ------ | ------ | ------ | ------ | ------ |
| Transações no Sistema de Pontos | 27/Jan/2024 a 23/Ago/2024 | 126.602 | Databricks (transacoes) | Teo Me Why |
| Transações e Identificação do Produto | 27/Jan/2024 a 23/Ago/2024 | 126.958 | Databricks (transacao_produto) | Teo Me Why |
| Clientes | 27/Jan/2024 a 23/Ago/2024 | 1772 | Databricks (cliente) | Teo Me Why |

### Descrição das variáveis

> A tabela analítica resultado do estudo (ABT) utilizada com as respectivas informações
> são apresentadas na tabela abaixo (TABLE abt_churn_project_churn):

| Variável | Tipo | Descrição |
| ----- | ----- | ----- |
| dtRef | Data | Data Referência (Safra) |
| idCliente | Texto | Identificador do Cliente |
| flChurn | Número | Target (churn ou não churn) |
| nrSomaPontos | Número | Soma dos Pontos |
| nrSomaPontosPos | Número | Soma dos Pontos Positivos |
| nrSomaPontosNeg | Número | Soma dos Pontos Negativos |
| nrTicketMedio | Número | Ticket Médio dos Pontos |
| nrTicketMedioPos | Número | Ticket Médio Positivo |
| nrTicketMedioNeg | Número | Ticket Médio Negativo |
| nrPontosDia | Número | Média Pontos por Dia |
| nrQtdeTransacoes | Número | Quantidade Total de Transações |
| nrQtdeDias | Número | Quantidade de Dias de Transações |
| nrRecenciaDias | Número | Recência (Tempo em Dias da última transação) |
| nrQtdeTransacaoDay2 | Número | Quantidade de Transações na Segunda-feira |
| nrQtdeTransacaoDay3 | Número | Quantidade de Transações na Terça-feira |
| nrQtdeTransacaoDay4 | Número | Quantidade de Transações na Quarta-feira |
| nrQtdeTransacaoDay5 | Número | Quantidade de Transações na Quinta-feira |
| nrQtdeTransacaoDay6 | Número | Quantidade de Transações na Sexta-feira |
| nrQtdeDay2 | Número | Quantidade de Dias na Segunda-feira |
| nrQtdeDay3 | Número | Quantidade de Dias na Terça-feira |
| nrQtdeDay4 | Número | Quantidade de Dias na Quarta-feira |
| nrQtdeDay5 | Número | Quantidade de Dias na Quintaa-feira |
| nrQtdeDay6 | Número | Quantidade de Dias na Sexta-feira |
| nrAvgRecorrencia | Número | Média de Recorrência entre uma transação e outra |
| varProdutosAcessados | Número | Variedade dos Produtos Acessados |
| qtdeProdChatMessage | Número | Mandou uma mensagem no chat (Top 1) | 
| qtdeProdListaPresenca | Número | Digitou !presente na Live (Top 2) |
| qtdeProdChurn5pp | Número | Digitou !profile e teve prob de churn < 5% (Top 3) |
| qtdeProdPresencaStreak | Número | Digitou !presente por 5 dias consecutivos (Top 4) |
| qtdeProdResgatarPonei | Número | Resgatou Pôneis da Twitch (Top 5) |
| qtdeProdTrocaPontosStreamElements | Número | Digitou !troca e trocou pontos por DtPoints (Top 6) |
| qtdeProdChurn10pp | Número | Digitou !profile e teve prob de churn < 10% (Top 7) |
| qtdeProdDailyLoot | Número | Resgatou Loot Diário de RPG (Top 8)|
| qtdeProdChurn2pp | Número | Digitou !profile e teve prob de churn < 2% (Top 9)|
| qtdeProdAirflowLover | Número | Citou o Airflow no chat (Top 10) |
| turnoMaisFrequente | Texto | Turno do usuário mais frequente de transações |

### Premissas e Limitações
* Premissas
  * O usuário pode se manter no canal em um determinado mês, abandonar o canal em um outro mês e retornar ao canal.
  * Existe três tipos de pontos no sistema de pontos do canal e alguns podem ser trocados em pontos de um outro tipo ou por itend na loja virtual. A base disponibiliza os pontos apenas do tipo Cubos, que são os pontos de CRM.
  
* Limitações
  * Usuários que abandonam o canal e retornam antes do primeiro dia do mês subsequente não serão corretamente identificados como tendo abandonado.
  * A base de dados está limitada a poucos meses (Fev a Ago) de um único ano.

## 2. Metodologia

### Análise Exploratória
...

### Descrição das técnicas utilizadas

- Tipo: Análise Bidimensional (Correlação de Spearman), Classificação. Considerando que as variáveis númericas seguem uma distribuição multimodal, foi utilizado o método de Spearman, para a análise das correlações entre as variáveis, por ser mais robusta e menos sensível a distribuições não normais e relações não lineares.
- Tipo de aprendizado: Supervisionado.
  * Etapas do Pipeline:
    * Pré-processamento: ColumnTransformer: Variáveis Númericas (SimpleImputer > StandardScaler); Variáveis Categóricas (SimpleImputer > OneHotEncoder).
    * Seleção de variáveis:
      * DropConstantFeatures: remoção das features constantes ou quase constantes;
      * DropCorrelatedFeatures;
      * SmartCorrelatedSelection (Random Forest): existência de várias features altamente correlacionadas. Foi definido o critério de seleção "model_performance" (melhor desempenho do modelo) para a seleção otimizada das features a serem mantidas no modelo;
      * RFE (Logistic Regression).
    * Otimização de hiperparâmetros: GridSearch (Logistic Regression).
- Variável resposta: binária (flChurn).
- Variáveis explicativas/features: variáveis originais (dtRef e idCliente) e engenhadas a partir dos dados presentes no datalake (descNomeProduto, nrPontosTransacao, dtTransacao(Time)).

![Pipeline do ML](https://github.com/anaramos5582/project-churn/blob/main/pipeline.png)

### Resultados obtidos
- Desempenho do Modelo

  O modelo alcançou uma acurácia de 79,29% nos dados de treino e 81,68% nos dados de teste, indicando uma leve melhora na capacidade do modelo de generalizar para novos dados. A acurácia, embora útil, não é a única métrica a ser considerada, especialmente em problemas de classificação desequilibrada.
  A Área Sob a Curva (AUC) foi de 0.8355 no treino e 0.7997 no teste, o que sugere que o modelo tem uma boa habilidade para distinguir entre as classes positivas e negativas. O AUC próximo de 0.8 no teste confirma que o modelo tem um bom desempenho, embora com uma pequena queda em relação aos dados de treino, o que pode indicar um leve overfitting, mas ainda dentro de um limite aceitável.

- Interpretação das Métricas de Classificação

  Conjunto de Treino:
  
    * Precision (0.80) e Recall (0.93) para a classe 1: O modelo é mais eficaz em identificar corretamente a classe 1 (classe majoritária), com alta capacidade de recuperar as instâncias dessa classe. A F1-Score de 0.86 indica um bom equilíbrio entre precision e recall para essa classe.
    * Precision (0.77) e Recall (0.50) para a classe 0: A classe 0, por outro lado, tem uma precisão razoável, mas com recall baixo, o que sugere que muitas instâncias da classe 0 foram incorretamente classificadas como 1.
    * Macro avg e Weighted avg refletem uma performance sólida, mas com uma variação perceptível entre as classes.
      
  Conjunto de Teste:
  
    * Precision (0.84) e Recall (0.92) para a classe 1: O desempenho na classe 1 se manteve forte, com um leve ajuste em comparação com os dados de treino, resultando em uma F1-Score de 0.88.
    * Precision (0.75) e Recall (0.58) para a classe 0: A classe 0 ainda apresenta desafios, com um recall relativamente baixo, indicando que o modelo ainda tem dificuldade em capturar todas as instâncias da classe 0 corretamente.
    * Macro avg e Weighted avg também indicam uma distribuição de desempenho consistente com o treino, mas com uma leve tendência de overfitting na classe majoritária.

### Macro fluxo da solução

...

### Planos de ação
* Envio por e-mail de notificações e lembretes personalizados sobre eventos ao vivo em horários diferentes, produtos disponíveis, mantendo os usuários informados e envolvidos.
* Conduzir uma pesquisa de satisfação abrangente com perguntas qualitativas e abertas dos motivos para não retorno ao canal.

## 3. Conclusão

### Deploy
* Periodicidade da escoragem: mensal;
* Tipo de disponibilização: tabela SQL;
* Local da disponibilização: Databricks;
* Ponto focal da disponibilização: Teo Me Why.
  
### Acompanhamento do modelo/estudo
* Performance do Modelo: Curva ROC, acurácia, recall e precisão no conjunto de treino.
* Taxa do target: no conjunto de treino, garantindo um fiel balanceamento dos dados.
  
O modelo mostra um desempenho geral sólido, especialmente na classe majoritária (1), com boa generalização nos dados de teste. As métricas de AUC sugerem que o modelo tem uma boa habilidade discriminativa, embora o desempenho na classe minoritária (0) possa ser melhorado, possivelmente por meio de técnicas adicionais de balanceamento de classes ou ajustes na seleção de features. O uso de técnicas como GridSearch e RFE ajudou a refinar o modelo, embora o foco em melhorar a recall da classe minoritária poderia ser uma área de otimização futura.

### Roadmap de melhorias
* Plano de ação para coletar novos dados;
* Segmentação de Usuários: segmentar os usuários com base em comportamento (frequência de interação, produtos adquiridos, etc.) para identificar grupos mais propensos a churn.
