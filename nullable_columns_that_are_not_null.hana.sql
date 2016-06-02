select  'select cast(null as nvarchar(128)) as "COLUMN_NAME" from dummy where 1=0 '
||      STRING_AGG(stmt) as stmt
from    (
        select ' union all '
        ||     'select '''||column_name||''' '
        ||     'from "'||schema_name||'"."'||table_name||'" '
        ||     'having count(*) = count('||column_name||')' as stmt
        from   table_columns 
        where  schema_name  = coalesce(?, current_schema)
        and    table_name   = ?
        and    is_nullable  = 'TRUE'
        order by position
        )
