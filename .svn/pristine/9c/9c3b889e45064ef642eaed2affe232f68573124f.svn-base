SELECT
  plan_hash_value,
  ROUND(BUFFER_GETS/(decode(executions,0,1,executions))) get_per_exec,
  executions
FROM
  v$sql
WHERE
  hash_value='&&v_sql_hash_value'
ORDER BY
  2 desc
;