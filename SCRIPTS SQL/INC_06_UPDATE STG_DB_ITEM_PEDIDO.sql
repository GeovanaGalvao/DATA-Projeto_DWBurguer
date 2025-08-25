UPDATE [dbo].[STG_DB_ITEM_PEDIDO]
   SET 
       [CD_PRODUTO_LOJA] = ?
      ,[QT_PEDIDO] = ?
      ,[VL_UNITARIO] = ?
      ,[VL_LUCRO_LIQUIDO] = ?
      ,[ST_ITEM_PEDIDO] = ?
 WHERE 
       NR_LOJA   = ?
 AND   NR_PEDIDO = ?
 AND   NR_ITEM   = ?

