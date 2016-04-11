define v_sql_hash_value=&v_sql_hash_value
select  /* for 9i */ plan_hash_value,child_number,executions,
to_char(last_active_time,'yyyymmdd hh24:mi:ss'),
to_char(FIRST_LOAD_TIME,'yyyymmdd hh24:mi:ss'),
loads 
from v$sql where hash_value=&&v_sql_hash_value order by child_number;