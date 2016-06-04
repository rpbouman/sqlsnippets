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
* Name: f_easter_day
* ------------------
*
* Parameters:
* -----------
* 1) P_YEAR SMALLINT (optional, default: year(current_date))
*
* Returns
* -------
* p_easter_date DATE
*
* Description:
* ------------
* Calculates the date of easter for the year passed as argument.
*
* Sources
* -------
* https://en.wikipedia.org/wiki/Computus
*
**/

create function f_easter_day(
  p_year smallint 
)
returns p_easter_date date
language sqlscript
sql security invoker
as
begin
  declare v_year smallint default ifnull(p_year, year(current_date));
  DECLARE a SMALLINT DEFAULT mod(v_year, 19);
  DECLARE b SMALLINT DEFAULT FLOOR(v_year / 100);
  DECLARE c SMALLINT DEFAULT mod(v_year, 100);
  DECLARE d SMALLINT DEFAULT FLOOR(b / 4);
  DECLARE e SMALLINT DEFAULT mod(b, 4);
  DECLARE f SMALLINT DEFAULT FLOOR((b + 8) / 25);
  DECLARE g SMALLINT DEFAULT FLOOR((b - f + 1) / 3);
  DECLARE h SMALLINT DEFAULT mod((19 * a + b - d - g + 15), 30);
  DECLARE i SMALLINT DEFAULT FLOOR(c / 4);
  DECLARE k SMALLINT DEFAULT mod(c, 4);
  DECLARE L SMALLINT DEFAULT mod((32 + 2 * e + 2 * i - h - k), 7);
  DECLARE m SMALLINT DEFAULT FLOOR((a + 11 * h + 22 * L) / 451);
  DECLARE v100 SMALLINT DEFAULT h + L - 7 * m + 114;
  p_easter_date = to_date(v_year||'-'||floor(v100 / 31)||'-'||(mod(v100, 31)+1), 'YYYY-MM-DD');  
end;
