SELECT t.codprod, p.condvenda, p.numped, p.numnota, p.data, t.qt
FROM pcpedc p, pcpedi t
WHERE p.numped = t.numped  -- Importante para ligar as tabelas
  AND p.codfilial = 6
  AND p.condvenda = 7
  AND t.codprod IN (1741, 7707)
  AND NOT EXISTS (
        SELECT 1
        FROM pcpedi t2
        WHERE t2.numped = p.NUMPEDENTFUT  -- Vínculo pela transação
          AND t2.codprod = t.codprod          -- Vínculo pelo produto
          AND t2.condvenda = 8               -- Procura a entrada
  );
