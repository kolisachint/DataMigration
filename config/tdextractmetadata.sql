.LOGON <TDServer>/<TDUser>,<TDPassword>;

.set width 10000

.EXPORT REPORT FILE = <TDTableMetadataFile>

SELECT
CAST(LOWER(TRIM(ColumnName))||'|'||
CASE
                WHEN TRIM(ColumnType) = 'AT' THEN 'TIME'
                WHEN TRIM(ColumnType) = 'CF' THEN 'STRING'
                WHEN TRIM(ColumnType) = 'CV' THEN 'STRING'
                WHEN (TRIM(ColumnType) = 'D' AND DecimalTotalDigits <= 19 AND DecimalFractionalDigits = 0) THEN 'INTEGER'
                WHEN (TRIM(ColumnType) = 'D' AND DecimalFractionalDigits > 0) THEN 'FLOAT'
                WHEN TRIM(ColumnType) = 'DA' THEN 'DATE'
                WHEN TRIM(ColumnType) = 'F' THEN 'FLOAT'
                WHEN TRIM(ColumnType) = 'I1' THEN 'INTEGER'
                WHEN TRIM(ColumnType) = 'I2' THEN 'INTEGER'
                WHEN TRIM(ColumnType) = 'I' THEN 'INTEGER'
                WHEN TRIM(ColumnType) = 'I8' THEN 'INTEGER'
                WHEN TRIM(ColumnType) = 'TS' THEN 'TIMESTAMP'
                WHEN TRIM(ColumnType) = 'TZ' THEN 'TIMESTAMP'
                ELSE 'NA'
END||'|'||
CASE WHEN TRIM(Nullable) = 'Y' THEN 'NULLABLE' ELSE 'REQUIRED' END||'|'||
COALESCE(TRIM(ColumnTitle),'')||'|'||
CASE
                WHEN (TRIM(ColumnType) = 'D' AND DecimalTotalDigits <= 19 AND DecimalFractionalDigits = 0) THEN LOWER(TRIM(ColumnName))||' - column datatype changed from DECIMAL('||TRIM(DecimalTotalDigits)||','||TRIM(DecimalFractionalDigits)||') to INTEGER'
                ELSE 'NA'
END
AS VARCHAR(10000))  AS Schematext
FROM dbc.COLUMNS
WHERE databasename='<DatabaseName>'
AND tablename= '<TableName>'
ORDER BY columnid;

.IF ERRORCODE <> 0 THEN .EXIT ERRORCODE;

.export reset

.LOGOFF

.EXIT
