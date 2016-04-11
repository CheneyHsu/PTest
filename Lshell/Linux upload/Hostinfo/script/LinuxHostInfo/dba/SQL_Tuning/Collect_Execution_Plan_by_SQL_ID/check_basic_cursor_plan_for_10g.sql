select /* for 10g */ 
plan_hash_value,child_number,executions,to_char(last_active_time,'yyyymmdd hh24:mi:ss'),
FIRST_LOAD_TIME ,loads 
from v$sql where sql_id='&&v_sql_id' order by child_number;