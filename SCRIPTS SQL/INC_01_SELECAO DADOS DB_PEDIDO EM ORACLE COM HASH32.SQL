--SELECT ORIGEM, COM HASH DE COMPARAÇÃO 32 BITS
SELECT 
    NR_LOJA,
    NR_PEDIDO,
    CD_FORMA_PAGTO,
    NR_CLIENTE,
    CD_LOGRADOURO_CLI,
    CD_FUNC_ATD,
    CD_FUNC_MOTOBOY,
    DT_PEDIDO,
    DT_PREV_ENTREGA,
    VL_TOT_PEDIDO,
    ST_PEDIDO,
    TO_NUMBER(
        SUBSTR(
            STANDARD_HASH(
                TO_CHAR(CD_FORMA_PAGTO) || '|' ||
                TO_CHAR(NR_CLIENTE) || '|' ||
                TO_CHAR(CD_LOGRADOURO_CLI) || '|' ||
                TO_CHAR(CD_FUNC_ATD) || '|' ||
                NVL(TO_CHAR(CD_FUNC_MOTOBOY), '') || '|' ||
                TO_CHAR(DT_PEDIDO, 'YYYYMMDD') || '|' ||
                NVL(TO_CHAR(DT_PREV_ENTREGA, 'YYYYMMDD'), '') || '|' ||
                NVL(TO_CHAR(VL_TOT_PEDIDO, 'FM9999999990.00'), '') || '|' ||
                ST_PEDIDO,
                'SHA1'
            ),
            1, 8
        ),
        'XXXXXXXX'
    ) AS HASH_NUM_32
    
FROM DB_PEDIDO
ORDER BY 
     NR_LOJA,
     NR_PEDIDO

