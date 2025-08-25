SELECT 
    NR_LOJA,
    NR_PEDIDO,
    NR_ITEM,
    CD_PRODUTO_LOJA,
    QT_PEDIDO,
    VL_UNITARIO,
    VL_LUCRO_LIQUIDO,
    ST_ITEM_PEDIDO,
    TO_NUMBER(
        SUBSTR(
            STANDARD_HASH(
                TO_CHAR(CD_PRODUTO_LOJA) || '|' ||
                NVL(TO_CHAR(QT_PEDIDO, 'FM99999990.00'), '') || '|' ||
                NVL(TO_CHAR(VL_UNITARIO, 'FM99999990.00'), '') || '|' ||
                NVL(TO_CHAR(VL_LUCRO_LIQUIDO, 'FM99999990.00'), '') || '|' ||
                NVL(ST_ITEM_PEDIDO, ''),
                'SHA1'
            ),
            1, 8
        ),
        'XXXXXXXX'
    ) AS HASH_NUM_32 
FROM DB_ITEM_PEDIDO
ORDER BY 
    NR_LOJA,
    NR_PEDIDO,
    NR_ITEM;

