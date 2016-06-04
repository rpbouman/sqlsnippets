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
* Name: pr_nullable_cols_not_null
* -------------------------------
*
* Parameters:
* -----------
* 1) SCHEMA_NAME NVARCHAR(128) (optional, default: CURRENT_SCHEMA)
* 2) TABLE_NAME  NVARCHAR(128)
*
* Description:
* ------------
* Uses the parameters to generate a SQL query that lists all nullable columns 
* which in fact do not contain any null values. 
* In other words, columns could be altered to be NOT NULL without error.
*
**/

create PROCEDURE PR_NULLABLE_COLS_NOT_NULL (
  p_schema_name nvarchar(128)
, p_table_name  nvarchar(128)
) 
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER 
--DEFAULT SCHEMA <default_schema_name>
AS
BEGIN
  declare v_stmt clob;

  select      'select cast(null as nvarchar(128)) as "SCHEMA_NAME" '
  ||char(10)||',      cast(null as nvarchar(128)) as "TABLE_NAME" '
  ||char(10)||',      cast(null as nvarchar(128)) as "COLUMN_NAME" '
  ||char(10)||'from dummy '
  ||char(10)||'where 1=0 '
  ||      STRING_AGG(stmt) as stmt
  into    v_stmt
  from    (
          select 
            char(10)||     'union all'
          ||char(10)||     'select cast('''||schema_name||''' as nvarchar(128)) '
          ||char(10)||     ',      cast('''||table_name||''' as nvarchar(128)) '
          ||char(10)||     ',      cast('''||column_name||''' as nvarchar(128)) '
          ||char(10)||     'from "'||schema_name||'"."'||table_name||'" '
          ||char(10)||     'having count(*) = sum(case when '||column_name||' is null then 0 else 1 end)' as stmt
          from   table_columns 
          where  schema_name  like coalesce(:p_schema_name, current_schema)
          and    table_name   like coalesce(:p_table_name, '%')
          and    is_nullable  = 'TRUE'
          order by position
  );
  
  execute immediate(:v_stmt);
END;