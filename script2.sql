SELECT DISTINCT 
    p.numped AS pedido_tv7, 
    (p.numped + 1) AS provavel_tv8,
    p.numnota AS nota_tv7, 
    p.DATA,
    r.chavenfe
FROM pcpedc p, pcnfsaid r
WHERE p.codfilial = 6
  AND p.condvenda = 7
  AND p.posicao = 'F'
  AND EXISTS (
      SELECT 1 
      FROM pcpedi t 
      WHERE t.numped = p.numped 
        AND t.codprod IN (1741, 7707)
  )
  AND NOT EXISTS (
      SELECT 1
      FROM pcpedc p8
      WHERE p8.numped = p.numped + 1   
        AND p8.condvenda = 8
        AND p8.posicao = 'F'
  );
