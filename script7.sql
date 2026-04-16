SELECT COALESCE(
               CASE
                   WHEN B.NUMBONUS NOT IN (SELECT NUMBONUS
                                           FROM PCNFENTPREENT
                                           WHERE NUMBONUS = B.NUMBONUS)
                       THEN (SELECT DISTINCT F.CODFORNEC || ' - ' || F.FORNECEDOR
                             FROM PCPRODUT P,
                                  PCBONUSI I,
                                  PCFORNEC F
                             WHERE I.CODPROD = P.CODPROD
                               AND F.CODFORNEC = I.CODFORNEC
                               AND I.NUMBONUS = B.NUMBONUS
                               AND ROWNUM = 1)
                   ELSE (SELECT DISTINCT F.CODFORNEC || '-' || F.FORNECEDOR
                         FROM PCFORNEC F,
                              PCNFENTPREENT E
                         WHERE E.CODFORNEC = F.CODFORNEC
                           AND E.NUMBONUS = B.NUMBONUS
                           AND NVL((SELECT COUNT(CODOPER)
                                    FROM PCMOVPREENT
                                    WHERE NUMTRANSENT = E.NUMTRANSENT
                                      AND (CODOPER = 'ED'
                                        OR CODOPER = 'EO'
                                        OR (CODOPER = 'ET' AND E.TIPODESCARGA = '6'))), 0) = 0
                           AND ROWNUM = 1)
                   END,
               (SELECT DISTINCT F.CODFORNEC || ' - ' || F.FORNECEDOR
                FROM PCBONUSI I
                         JOIN PCFORNEC F ON (I.CODFORNEC = F.CODFORNEC)
                WHERE I.NUMBONUS = B.NUMBONUS
                  AND ROWNUM = 1),
               (SELECT DISTINCT F.CODFORNEC || ' - ' || F.FORNECEDOR
                FROM PCBONUSI I
                         JOIN PCPRODUT P ON (I.CODPROD = P.CODPROD)
                         JOIN PCFORNEC F ON (P.CODFORNEC = F.CODFORNEC)
                WHERE I.NUMBONUS = B.NUMBONUS
                  AND ROWNUM = 1)
       ) AS FORNECEDOR,
       B.NUMBONUS,
       B.DATABONUS,
       B.PESOTOTAL
FROM PCBONUSC B
WHERE B.NUMBONUS IN (SELECT DISTINCT NUMBONUS
                     FROM PCBONUSI I,
                          PCPRODUT P
                     WHERE I.CODPROD = P.CODPROD
                       AND P.LOCALSEPARACAO = 'EF')
  AND B.DTFECHAMENTO IS NULL
  AND B.CODFILIAL IN (:codigo_filial)
  AND TRUNC(B.DTMONTAGEM) > (TRUNC(SYSDATE) - 30)
ORDER BY B.NUMBONUS DESC;
