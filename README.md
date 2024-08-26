#   p r o j e c t - c h u r n 
<br>
# Introdução e escopo
## Objetivo do modelo
<br>
Este modelo possui como objetivo estimar a probabilidade de Churn (abandono) de um usuário no canal Téo Me Why, com base nos dados que temos no datalake.
O churn é definido como abandono do canal após um período de 28 dias sem transação.
É esperado que a utilização do modelo ajude a reduzir a taxa de churn, e por consequência aumente a movimentação na comunidade do canal TeoMeWhy.
<br>
## Histórico de versões
<br>
<table>
  <tr><td>Versão</td><td>Data</td><td>Responsáveis</td><td>Descrição</td></tr>
  <tr><td>V1.0</td><td>26/08/2024</td><td>Ana Paula Barros Ramos e Maria Fernanda</td><<td>Desenvolvimento do modelo de Churn de Usuários</td></tr>
</table>

<br>
## Visão regulatória
<br>
No escopo do churn, não existem regulamentações que tenham impacto no tema.
<br>
## Papéis e responsabilidades
<br>
O projeto será realizado conjuntamente pelas áreas, responsáveis e ponto focal indicados abaixo.
<br>
<table>
  <tr><td>Papel/Atividade</td><td>Área responsável</td><td>Ponto focal</td></tr>
  <tr><td>Descrição do Processo</td><td>Sistemas de ponto do Canal TeoMeWhy</td><td>Canal TeoMeWhy</td></tr>
  <tr><td>Disponibilização dos Dados</td><td>Databricks</td><td>Canal TeoMeWhy & MeD</td></tr>
  <tr><td>Análise Exploratória Inicial</td><td>Análise de Dados</td><td>Ana Paula e Maria Fernanda</td></tr>
  <tr><td>Desenvolvimento do Modelo</td><td>Ciência de Dados</td><td>Ana Paula e Maria Fernanda</td></tr>
  <tr><td>Validação da Metodologia </td><td>Validação do Modelo</td><td>Teo Me Why</td></tr>
</table>
<br>
## Público alvo
<br>
O público alvo considerado para a construção do target deste modelo foi selecionado a partir das características abaixo:
* Transações de usuários realizadas nos períodos entre as seguintes datas de referência: 01/02/2024, 01/03/2024, 01/04/2024, 01/05/2024, 01/06/2024, 01/07/2024, 01/08/2024 e seus últimos 28 dias antecedentes.
<br>
## Target
<br>
A variável target do modelo é do tipo binária e será construída avaliando as transações realizadas pelos usuários na respectiva data de referência.
Churn: usuário abandona o canal em até 28 dias após a data de referência.
Não Churn: caso contrário.
<br>

## Bases de dados utilizadas
<br>
As bases de dados utilizadas com as respectivas informações são apresentadas na tabela abaixo:
<table>
  <tr><td>Base de dados</td><td>Datas base de referência</td><td>Quantidade de observações</td><td>Fonte de informação</td><td>Responsável pela disponibilização</td></tr>
  <tr><td>Transações no Sistema de Pontos</td><td>27/Jan/2024 a 23/Ago/2024</td><td>126.602</td><td>Databricks (transacoes)</td><td>Teo Me Why</td></tr>
   <tr><td>Transações e Identificação do Produto</td><td>27/Jan/2024 a 23/Ago/2024</td><td>126.958</td><td>Databricks (transacao_produto)</td><td>Teo Me Why</td></tr>
   <tr><td>Clientes</td><td>27/Jan/2024 a 23/Ago/2024</td><td>1772</td><td>Databricks (cliente)</td><td>Teo Me Why</td></tr>
</table>
<br>
## Descrição das variáveis
<br>
A tabela analítica resultado do estudo (ABT) utilizada com as respectivas informações são apresentadas na tabela abaixo:
<br>
...
<br>
## Premissas e Limitações
* Premissas
  ** O usuário pode se manter no canal em um determinado mês, abandonar o canal em um outro mês e retornar ao canal.
<br>
* Limitações
  ** Usuários que abandonam o canal e retornam antes do primeiro dia do mês subsequente não serão corretamente identificados como tendo abandonado.
  ** A base de dados está limitada a poucos meses de um único ano.
<br>

# Metodologia
<br>
## Análise Exploratória
...

## Descrição das técnicas utilizadas

...
## Resultados obtidos

...

## Macro fluxo da solução

...

## Planos de ação
...

# Conclusão

## Deploy
* Periodicidade da escoragem: mensal;
* Tipo de disponibilização: tabela SQL;
* Local da disponibilização: Databricks;
* Ponto focal da disponibilização: Teo Me Why.
  
## Acompanhamento do modelo/estudo
* Performance do Modelo: Curva ROC, acurácia e precisão no conjunto de treino;
* Taxa do target: no conjunto de treino, garantindo um fiel balanceamento dos dados.
...

## Roadmap de melhorias
* Plano de ação para coletar novos dados;
* Criação ovas variáveis;

 
 
