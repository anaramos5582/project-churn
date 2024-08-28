SELECT 
       '{date}' AS dtRef,
       idCliente,
       sum(nrPontosTransacao) AS nrSomaPontos,
       sum(CASE WHEN nrPontosTransacao > 0 THEN nrPontosTransacao ELSE 0 END) AS nrSomaPontosPos,
       sum(CASE WHEN nrPontosTransacao < 0 THEN nrPontosTransacao ELSE 0 END) AS nrSomaPontosNeg,
       
       sum(nrPontosTransacao) / count(distinct idTransacao) AS nrTicketMedio,
       
       coalesce(sum(CASE WHEN nrPontosTransacao > 0 THEN nrPontosTransacao ELSE 0 END) / count( distinct CASE WHEN nrPontosTransacao > 0 THEN idTransacao END),0) AS nrTicketMedioPos,
       
       coalesce(sum(CASE WHEN nrPontosTransacao < 0 THEN nrPontosTransacao ELSE 0 END) / count( distinct CASE WHEN nrPontosTransacao < 0 THEN idTransacao END), 0) AS nrTicketMedioNeg,

       sum(nrPontosTransacao) / count(distinct date(dtTransacao)) AS nrPontosDia


FROM silver.upsell.transacoes

WHERE dtTransacao < '{date}'                   -- DATA DA SAFRA
AND dtTransacao >= '{date}' - INTERVAL 28 DAY  -- JANELA DE OBSERVACAO

GROUP BY ALL