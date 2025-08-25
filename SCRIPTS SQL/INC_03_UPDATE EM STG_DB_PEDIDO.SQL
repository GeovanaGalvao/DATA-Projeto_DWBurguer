UPDATE STG_DB_PEDIDO
   SET 
       [CD_FORMA_PAGTO] = ?
      ,[NR_CLIENTE] = ?
      ,[CD_LOGRADOURO_CLI] = ?
      ,[CD_FUNC_ATD] = ?
      ,[CD_FUNC_MOTOBOY] = ?
      ,[DT_PEDIDO] = ?
      ,[DT_PREV_ENTREGA] = ?
      ,[VL_TOT_PEDIDO] = ?
      ,[ST_PEDIDO] = ?
 WHERE 
     NR_LOJA   = ?
AND  NR_PEDIDO = ?

