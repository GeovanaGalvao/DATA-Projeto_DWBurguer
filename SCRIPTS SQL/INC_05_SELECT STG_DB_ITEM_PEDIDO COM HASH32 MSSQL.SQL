SELECT 
    NR_LOJA,
    NR_PEDIDO,
    NR_ITEM,
    CAST(
        CONVERT(BIGINT,
            CONVERT(VARBINARY(4),
                HASHBYTES('SHA1',
                    CAST(
					CAST(CD_PRODUTO_LOJA AS VARCHAR) + '|' +
                    FORMAT(QT_PEDIDO, '0.00') + '|' +
                    FORMAT(VL_UNITARIO, '0.00') + '|' +
                    FORMAT(VL_LUCRO_LIQUIDO, '0.00') + '|' +
                    ISNULL(ST_ITEM_PEDIDO, '')  AS varchar(200) )COLLATE Latin1_General_BIN2
                )
            )
        ) & 0xFFFFFFFF AS BIGINT
    ) AS HASH_NUM_32
	FROM STG_DB_ITEM_PEDIDO WITH (NOLOCK)
ORDER BY 
    NR_LOJA,
    NR_PEDIDO,
         NR_ITEM
