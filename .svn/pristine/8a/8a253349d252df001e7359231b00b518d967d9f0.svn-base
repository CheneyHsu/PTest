SELECT
  'GRANT SELECT ON '||owner||'.'||table_name||' TO SYSTEM;  -- LAST ANA: '||TO_CHAR(last_analyzed,'yyyymmdd hh24:mi:ss')
FROM
  dba_tables t,
  (
    SELECT DISTINCT
      object_owner,
      object_name
    FROM
      v$sql_plan
    WHERE
      sql_id       ='&&v_sql_id'
    AND object_type='TABLE'
  )
  p
WHERE
  t.table_name=p.object_name
AND t.owner   =p.object_owner
ORDER BY
  last_analyzed 
;