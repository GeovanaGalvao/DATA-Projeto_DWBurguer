--SELECT DESTINO STG_DB_PEDIDO, COM HASH DE COMPARAÇÃO 32 BITS
SELECT
    NR_LOJA,
    NR_PEDIDO,
    CAST(
        CONVERT(BIGINT,
            CONVERT(VARBINARY(4),
                HASHBYTES('SHA1',
                    CAST(
                        CAST(CD_FORMA_PAGTO AS varchar) + '|' +
                        CAST(NR_CLIENTE AS varchar) + '|' +
                        CAST(CD_LOGRADOURO_CLI AS varchar) + '|' +
                        CAST(CD_FUNC_ATD AS varchar) + '|' +
                        ISNULL(CAST(CD_FUNC_MOTOBOY AS varchar), '') + '|' +
                        CONVERT(varchar, DT_PEDIDO, 112) + '|' +
                        ISNULL(CONVERT(varchar, DT_PREV_ENTREGA, 112), '') + '|' +
                        ISNULL(REPLACE(STR(VL_TOT_PEDIDO, 10, 2), ' ', ''), '') + '|' +
                        ST_PEDIDO
                    AS varchar(200)
                    ) COLLATE Latin1_General_CI_AS
                )
            )
        ) & 0xFFFFFFFF AS BIGINT
    ) AS HASH_NUM_32
FROM dbo.STG_DB_PEDIDO with (NOLOCK)

ORDER BY
        NR_LOJA,
	   NR_PEDIDO

