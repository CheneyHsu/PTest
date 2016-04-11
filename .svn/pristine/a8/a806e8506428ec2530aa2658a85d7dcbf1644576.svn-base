SELECT
  'GRANT SELECT ON '||owner||'.'||table_name||' TO SYSTEM;  -- LAST ANA: '||TO_CHAR(last_analyzed,'yyyymmdd hh24:mi:ss')
FROM
  dba_tables t,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value='&&v_sql_hash_value'
    and o.object_type='TABLE'	
	) p
WHERE
  t.table_name=p.object_name
and t.owner=p.object_owner
ORDER BY
  last_analyzed 
;