/**
* Copyright 2016 Roland.Bouman@gmail.com, Roland.Bouman@just-bi.nl,
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* Name: nullable_columns_tat_are_not_null
* ---------------------------------------
*
* Parameters:
* -----------
* 1) SCHEMA_NAME (optional, default: CURRENT_SCHEMA)
* 2) TABLE_NAME
*
* Description:
* ------------
* Uses the parameters to generate a SQL query that lists all nullable columns 
* which in fact do not contain any null values. 
* In other words, columns could be altered to be NOT NULL without error.
*
**/

select  'select cast(null as nvarchar(128)) as "COLUMN_NAME" '
||      'from dummy '
||      'where 1=0 '
||      STRING_AGG(stmt) as stmt
from    (
        select char(10)||'union all'||char(10)
        ||     'select '''||column_name||''' '
        ||     'from "'||schema_name||'"."'||table_name||'" '
        ||     'having count(*) = count('||column_name||')' as stmt
        from   table_columns 
        where  schema_name  = coalesce(?, current_schema)
        and    table_name   = ?
        and    is_nullable  = 'TRUE'
        order by position
        )
;