SELECT /* for 10g */
  plan_hash_value,
  ROUND(BUFFER_GETS/(decode(executions,0,1,executions))) gets_per_exec,
  TO_CHAR(LAST_ACTIVE_TIME,'yyyymmdd hh24:mi:ss') last_act,last_load_time,loads,invalidations,executions,
  object_status
FROM
  v$sql
WHERE
  sql_id='&&v_sql_id'
ORDER BY
  last_act 
;