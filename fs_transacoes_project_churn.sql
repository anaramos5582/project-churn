WITH tb_transacoes AS (

    SELECT *,

           date(dtTransacao) AS diaTransacao,
           CASE
             WHEN HOUR(dtTransacao) BETWEEN 5 AND 11 THEN 'Manha'
             WHEN HOUR(dtTransacao) BETWEEN 12 AND 17 THEN 'Tarde'
             WHEN HOUR(dtTransacao) BETWEEN 18 AND 23 THEN 'Noite'
             WHEN HOUR(dtTransacao) BETWEEN 0 AND 4 THEN 'Madrugada'
            END AS turnoTransacao

    FROM silver.upsell.transacoes

    WHERE dtTransacao < '{date}' 
    AND dtTransacao >= '{date}' - INTERVAL 28 DAY

),

tb_agrupada AS (

    SELECT 
          idCliente,
          COUNT(DISTINCT t1.dtTransacao) AS nrQtdeTransacoes,
          COUNT(DISTINCT date(t1.dtTransacao) ) AS nrQtdeDias,
          MIN(datediff('{date}' , date(t1.dtTransacao))) AS nrRecenciaDias,
          COUNT(CASE WHEN dayofweek(t1.dtTransacao) = 2 then t1.idTransacao end) AS nrQtdeTransacaoDay2,
          COUNT(CASE WHEN dayofweek(t1.dtTransacao) = 3 then t1.idTransacao end) AS nrQtdeTransacaoDay3,
          COUNT(CASE WHEN dayofweek(t1.dtTransacao) = 4 then t1.idTransacao end) AS nrQtdeTransacaoDay4,
          COUNT(CASE WHEN dayofweek(t1.dtTransacao) = 5 then t1.idTransacao end) AS nrQtdeTransacaoDay5,
          COUNT(CASE WHEN dayofweek(t1.dtTransacao) = 6 then t1.idTransacao end) AS nrQtdeTransacaoDay6,

          COUNT(DISTINCT CASE WHEN dayofweek(t1.dtTransacao) = 2 then date(t1.dtTransacao) end) AS nrQtdeDay2,
          COUNT(DISTINCT CASE WHEN dayofweek(t1.dtTransacao) = 3 then date(t1.dtTransacao) end) AS nrQtdeDay3,
          COUNT(DISTINCT CASE WHEN dayofweek(t1.dtTransacao) = 4 then date(t1.dtTransacao) end) AS nrQtdeDay4,
          COUNT(DISTINCT CASE WHEN dayofweek(t1.dtTransacao) = 5 then date(t1.dtTransacao) end) AS nrQtdeDay5,
          COUNT(DISTINCT CASE WHEN dayofweek(t1.dtTransacao) = 6 then date(t1.dtTransacao) end) AS nrQtdeDay6,

          COUNT(DISTINCT  t2.descNomeProduto) AS varProdutosAcessados,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'ChatMessage' THEN t1.idTransacao END) AS qtdeProdChatMessage,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Lista de presença' THEN t1.idTransacao END) AS qtdeProdListaPresenca,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Churn_5pp' THEN t1.idTransacao END) AS qtdeProdChurn5pp,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Presença Streak' THEN t1.idTransacao END) AS qtdeProdPresencaStreak,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Resgatar Ponei' THEN t1.idTransacao END) AS qtdeProdResgatarPonei,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Troca de Pontos StreamElements' THEN t1.idTransacao END) AS qtdeProdTrocaPontosStreamElements,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Churn_10pp' THEN t1.idTransacao END) AS qtdeProdChurn10pp,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Daily Loot' THEN t1.idTransacao END) AS qtdeProdDailyLoot,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Churn_2pp' THEN t1.idTransacao END) AS qtdeProdChurn2pp,
          COUNT(CASE WHEN TRIM(t2.descNomeProduto) = 'Airflow Lover' THEN t1.idTransacao END) AS qtdeProdAirflowLover

    FROM tb_transacoes AS t1
    LEFT JOIN silver.upsell.transacao_produto AS t2 
    ON t1.idTransacao = t2.idTransacao
    GROUP BY idCliente

),

tb_cliente_dia AS (

    SELECT DISTINCT
          idCliente,
          diaTransacao

    FROM tb_transacoes
    ORDER BY idCliente, diaTransacao

),

tb_cliente_lag AS (

    SELECT *,
          lag(diaTransacao) OVER (PARTITION BY idCliente ORDER BY diaTransacao) AS lagDia

    FROM tb_cliente_dia

),

tb_recorrencia AS (

    select idCliente,
          avg(datediff(diaTransacao, lagDia)) AS nrAvgRecorrencia

    from tb_cliente_lag

    GROUP BY idCliente
),

tb_frequencia_turno AS (
    SELECT 
        idCliente,
        turnoTransacao,
        COUNT(*) AS contTurno,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY COUNT(*) DESC) AS rn
    FROM 
        tb_transacoes
    GROUP BY 
        idCliente, 
        turnoTransacao
),

tb_turno_mais_frequente AS (
    SELECT 
    idCliente, 
    turnoTransacao AS turnoMaisFrequente
    FROM 
    tb_frequencia_turno
    WHERE 
    rn = 1
)


SELECT 
       '{date}' AS dtRef,
       t1.*,
       t2.nrAvgRecorrencia,
       t3.turnoMaisFrequente

FROM tb_agrupada AS t1

LEFT JOIN tb_recorrencia AS t2
ON t1.idCliente = t2.idCliente
LEFT JOIN tb_turno_mais_frequente AS t3
ON t1.idCliente = t3.idCliente