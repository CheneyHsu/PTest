set long 9999
select /* for 10g */ 
sql_id,to_char(LAST_ACTIVE_TIME,'yyyymmdd hh24:mi:ss'),
sql_fulltext
from v$sqlstats 
where sql_id='&&v_sql_id' 
order by plan_hash_value;