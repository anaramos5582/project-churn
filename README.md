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

- Tipo: Análise Bidimensional (Correlação), Classificação.
- Tipo de aprendizado: Supervisionado.
  * Etapas do Pipeline:
    * Pré-processamento: ColumnTransformer: Variáveis Númericas (SimpleImputer > StandardScaler); Variáveis Categóricas (SimpleImputer > OneHotEncoder).
    * Seleção de variáveis: DropConstantFeatures, DropCorrelatedFeatures, SmartCorrelatedSelection (Random Forest), RFE (Logistic Regression).
    * Seleção Parâmetros/Modelo: GridSearch (Logistic Regression).
- Variável resposta: binária (flChurn).
- Variáveis explicativas/features: variáveis originais (dtRef e idCliente) e engenhadas a partir dos dados presentes no datalake (descNomeProduto, nrPontosTransacao, dtTransacao(Time)).

### Resultados obtidos

...

### Macro fluxo da solução

...

### Planos de ação
...

## 3. Conclusão

### Deploy
* Periodicidade da escoragem: mensal;
* Tipo de disponibilização: tabela SQL;
* Local da disponibilização: Databricks;
* Ponto focal da disponibilização: Teo Me Why.
  
### Acompanhamento do modelo/estudo
* Performance do Modelo: Curva ROC, acurácia e precisão no conjunto de treino;
* Taxa do target: no conjunto de treino, garantindo um fiel balanceamento dos dados.


### Roadmap de melhorias
* Plano de ação para coletar novos dados;
* Criação de novas variáveis.
