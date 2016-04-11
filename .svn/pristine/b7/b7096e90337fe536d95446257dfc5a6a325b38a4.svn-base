SELECT
  plan_hash_value,
  ROUND(BUFFER_GETS_TOTAL/(executions_total+1)) get_per_exec,
  executions_total,
  snap_id
FROM
  dba_hist_sqlstat
WHERE
  sql_id='&&v_sql_id'
ORDER BY
  2 desc
;