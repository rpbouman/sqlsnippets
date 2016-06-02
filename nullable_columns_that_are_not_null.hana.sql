with    nullable_columns_that_are_not_null as (
        select case position 
                 when 1 then '' 
                 else ' union all ' 
               end
        ||     'select '''||column_name||''' '
        ||     'from INVENTORY_OPTIMIZATION4 '
        ||     'having count(*) = count('||column_name||')' as stmt
        from   table_columns 
        where  schema_name  = coalesce(?, current_schema)
        and    table_name   = ?
        and    is_nullable  = 'TRUE'
        order by position)
select  STRING_AGG(stmt) stmt
from    nullable_columns_that_are_not_null 