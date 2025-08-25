--SCRIPT SQL PARA LIMPAR F_PEDIDO (TRUNCAR OU DELETAR CONFORME VARI�VEL TP_CARGA)

-- Quando o primeiro par�metro (?) for igual a 'F', executa TRUNCATE
IF EXISTS (SELECT 1 WHERE ? = 'F')
    TRUNCATE TABLE F_PEDIDO;
ELSE
    -- Caso contr�rio, executa DELETE com base no segundo par�metro (DT_REFERENCIA)
    DELETE FROM F_PEDIDO 
    WHERE EXISTS (
        SELECT 1 
        FROM D_DATA
        WHERE F_PEDIDO.SK_DT_PEDIDO = D_DATA.SK_DATA
        AND D_DATA.DT_REFERENCIA >= ?
    );
