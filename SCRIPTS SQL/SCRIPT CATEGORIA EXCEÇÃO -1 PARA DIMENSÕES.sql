--SCRIPT SQL PARA POPULAR CATEGORIA DE EXCEÇÃO -1 NÃO SE APLICA 

DECLARE @DimTables TABLE (DimTable NVARCHAR(128));

-- Adicione aqui todas as tabelas de dimensão que deseja processar
INSERT INTO @DimTables (DimTable)
VALUES 
    ('D_CLIENTE'), 
    ('D_PRODUTO'), 
    ('D_LOJA'), 
    ('D_FUNCIONARIO'), 
    ('D_STATUS_TIPO');

DECLARE @DimTable NVARCHAR(128);
DECLARE @SKColumn NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @ExistsCheck NVARCHAR(MAX);
DECLARE @RecordExists INT;

-- Definição de valores padrão para categorias de exceção
DECLARE @ValorPadrao NVARCHAR(50) = 'NÃO SE APLICA';
DECLARE @ValorChaveNegativa INT = -1;
DECLARE @ValorAbv NVARCHAR(10) = 'N/A';
DECLARE @ValorChar2 CHAR(2) = '-1';
DECLARE @ValorChar1 CHAR(1) = 'X';
DECLARE @ValorNumericoPadrao INT = 0;

DECLARE DimCursor CURSOR FOR 
    SELECT DimTable FROM @DimTables;

OPEN DimCursor;
FETCH NEXT FROM DimCursor INTO @DimTable;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Obter dinamicamente o nome da coluna SK_
    SELECT TOP 1 @SKColumn = COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @DimTable 
      AND COLUMN_NAME LIKE 'SK_%';

    -- Construir a verificação de existência dinamicamente
    IF @SKColumn IS NOT NULL
    BEGIN
        SET @ExistsCheck = 
            'SELECT @RecordExists = COUNT(1) FROM ' + 
            QUOTENAME(@DimTable) + 
            ' WHERE ' + QUOTENAME(@SKColumn) + 
            ' = ' + CAST(@ValorChaveNegativa AS NVARCHAR);

        EXEC sp_executesql @ExistsCheck, 
            N'@RecordExists INT OUTPUT', 
            @RecordExists OUTPUT;
    END

    IF @SKColumn IS NOT NULL AND @RecordExists = 0
    BEGIN
        SET @SQL = 'SET IDENTITY_INSERT ' + QUOTENAME(@DimTable) + ' ON; ';

        DECLARE @Columns NVARCHAR(MAX) = '';
        DECLARE @Values NVARCHAR(MAX) = '';

        SELECT 
            @Columns = STRING_AGG(QUOTENAME(COLUMN_NAME), ', '),
            @Values = STRING_AGG(
                CASE 
                    WHEN COLUMN_NAME = @SKColumn THEN CAST(@ValorChaveNegativa AS NVARCHAR)
                    WHEN DATA_TYPE = 'char' AND CHARACTER_MAXIMUM_LENGTH = 1 THEN '''' + @ValorChar1 + ''''
                    WHEN DATA_TYPE IN ('char', 'varchar') AND CHARACTER_MAXIMUM_LENGTH = 2 THEN '''' + @ValorChar2 + ''''
                    WHEN COLUMN_NAME LIKE 'CD_%' AND DATA_TYPE IN ('smallint', 'int', 'bigint') THEN CAST(@ValorChaveNegativa AS NVARCHAR)
                    WHEN COLUMN_NAME LIKE 'CD_%' THEN '''' + @ValorPadrao + ''''
                    WHEN DATA_TYPE IN ('char', 'varchar') AND CHARACTER_MAXIMUM_LENGTH >= 13 THEN '''' + @ValorPadrao + ''''
                    WHEN DATA_TYPE IN ('char', 'varchar') AND CHARACTER_MAXIMUM_LENGTH < 13 THEN '''' + @ValorAbv + ''''
                    WHEN DATA_TYPE IN ('date', 'datetime', 'datetime2') THEN 
                        CASE 
                            WHEN COLUMN_NAME in ( 'DT_CRI_RGT', 'DT_INICIO', 'DT_CADASTRAMENTO', 'DT_NASCIMENTO') THEN 'GETDATE()'  
							ELSE 'NULL' 
                        END
                    WHEN DATA_TYPE IN ('numeric', 'decimal', 'int', 'bigint', 'smallint', 'tinyint', 'float', 'real') THEN CAST(@ValorNumericoPadrao AS NVARCHAR)
                    ELSE 'NULL'
                END, ', ')
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @DimTable;

        SET @SQL = @SQL + 
            'INSERT INTO ' + QUOTENAME(@DimTable) + 
            ' (' + @Columns + ') VALUES (' + @Values + ');';

        SET @SQL = @SQL + ' SET IDENTITY_INSERT ' + QUOTENAME(@DimTable) + ' OFF;';

        PRINT @SQL;
        EXEC sp_executesql @SQL;
    END

    FETCH NEXT FROM DimCursor INTO @DimTable;
END

CLOSE DimCursor;
DEALLOCATE DimCursor;