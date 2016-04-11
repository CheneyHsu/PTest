SELECT
  plan_hash_value,
  ROUND(BUFFER_GETS_TOTAL/(executions_total+1)) get_per_exec,
  executions_total,
  l.snap_id,
  to_char(n.begin_interval_time,'yyyymmdd hh24:mi:ss') snap_time
FROM
  dba_hist_sqlstat l,
  dba_hist_snapshot n
WHERE
  l.dbid=n.dbid and
  l.instance_number=n.instance_number and
  l.snap_id=n.snap_id and
  sql_id='&&v_sql_id'
ORDER BY
  l.snap_id
;