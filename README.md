# Project Churn

## Introdução e Escopo

## Objetivo do Modelo

Este modelo possui como objetivo estimar a probabilidade de Churn (abandono) de um usuário no canal Téo Me Why, com base nos dados que temos no datalake. O churn é definido como abandono do canal após um período de 28 dias sem transação. É esperado que a utilização do modelo ajude a reduzir a taxa de churn, e por consequência, aumente a movimentação na comunidade do canal Téo Me Why.

## Histórico de Versões

| Versão | Data       | Responsáveis                         | Descrição                              |
|--------|------------|--------------------------------------|----------------------------------------|
| V1.0   | 26/08/2024 | Ana Paula Barros Ramos e Maria Fernanda | Desenvolvimento do modelo de Churn de Usuários |

## Visão Regulatória

No escopo do churn, não existem regulamentações que tenham impacto no tema.

## Papéis e Responsabilidades

O projeto será realizado conjuntamente pelas áreas, responsáveis e ponto focal indicados abaixo.

| Papel/Atividade            | Área Responsável                    | Ponto Focal                           |
|----------------------------|-------------------------------------|---------------------------------------|
| Descrição do Processo       | Sistemas de ponto do Canal Téo Me Why | Canal Téo Me Why                     |
| Disponibilização dos Dados  | Databricks                          | Canal Téo Me Why & MeD               |
| Análise Exploratória Inicial| Análise de Dados                    | Ana Paula e Maria Fernanda            |
| Desenvolvimento do Modelo   | Ciência de Dados                    | Ana Paula e Maria Fernanda            |
| Validação da Metodologia    | Validação do Modelo                 | Téo Me Why                            |

## Público Alvo

O público alvo considerado para a construção do target deste modelo foi selecionado a partir das características abaixo:

- Transações de usuários realizadas nos períodos entre as seguintes datas de referência: 01/02/2024, 01/03/2024, 01/04/2024, 01/05/2024, 01/06/2024, 01/07/2024, 01/08/2024 e seus últimos 28 dias antecedentes.

## Target

A variável target do modelo é do tipo binária e será construída avaliando as transações realizadas pelos usuários na respectiva data de referência.

- **Churn**: usuário abandona o canal em até 28 dias após a data de referência.
- **Não Churn**: caso contrário.

## Bases de Dados Utilizadas

As bases de dados utilizadas com as respectivas informações são apresentadas na tabela abaixo:

| Base de Dados                     | Datas Base de Referência | Quantidade de Observações | Fonte de Informação              | Responsável pela Disponibilização |
|-----------------------------------|--------------------------|---------------------------|----------------------------------|-----------------------------------|
| Transações no Sistema de Pontos   | 27/Jan/2024 a 23/Ago/2024 | 126.602                   | Databricks (transacoes)          | Téo Me Why                        |
| Transações e Identificação do Produto | 27/Jan/2024 a 23/Ago/2024 | 126.958                   | Databricks (transacao_produto)   | Téo Me Why                        |
| Clientes                          | 27/Jan/2024 a 23/Ago/2024 | 1.772                      | Databricks (cliente)             | Téo Me Why                        |

## Descrição das Variáveis

A tabela analítica resultado do estudo (ABT) utilizada com as respectivas informações são apresentadas na tabela abaixo:


## Premissas e Limitações

### Premissas

- O usuário pode se manter no canal em um determinado mês, abandonar o canal em um outro mês e retornar ao canal.

### Limitações

- Usuários que abandonam o canal e retornam antes do primeiro dia do mês subsequente não serão corretamente identificados como tendo abandonado.
- A base de dados está limitada a poucos meses de um único ano.

# Metodologia

## Análise Exploratória

## Descrição das Técnicas Utilizadas

## Resultados Obtidos

## Macro Fluxo da Solução

## Planos de Ação

## Conclusão

## Deploy

- **Periodicidade da Escoragem**: mensal
- **Tipo de Disponibilização**: tabela SQL
- **Local da Disponibilização**: Databricks
- **Ponto Focal da Disponibilização**: Téo Me Why

## Acompanhamento do Modelo/Estudo

- **Performance do Modelo**: Curva ROC, acurácia e precisão no conjunto de treino.
- **Taxa do Target**: no conjunto de treino, garantindo um fiel balanceamento dos dados.

## Roadmap de Melhorias

- Plano de ação para coletar novos dados.
- Criação de novas variáveis.
