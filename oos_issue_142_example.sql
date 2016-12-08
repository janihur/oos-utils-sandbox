col human_readable for a60

with
numbers(num) as (
  select 123 from dual union all
  select 1234 from dual union all
  select 12345 from dual union all
  select 123456 from dual union all
  select 1234567 from dual union all
  select 12345678 from dual union all
  select 123456789 from dual union all
  select 1234567890 from dual union all
  select 1234567890e+1 from dual union all
  select 1234567890e+2 from dual union all
  select 1234567890e+3 from dual union all
  select 1234567890e+4 from dual union all
  select 1234567890e+5 from dual union all
  select 1234567890e+10 from dual union all
  select 1234567890e+20 from dual
),
units(unit) as (
  select   '' from dual union all
  select  'B' from dual union all
  select 'KB' from dual union all
  select 'MB' from dual union all
  select 'GB' from dual union all
  select 'TB' from dual union all
  select 'PB' from dual union all
  select 'EB' from dual union all
  select 'ZB' from dual union all
  select 'YB' from dual
)
select
 num
,unit
,oos_issue_142.to_human(num, unit, 'IEC') as human_readable
from numbers
cross join units
;
