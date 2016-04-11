SELECT
PKC.OBJECT_TYPE,
PKC.OWNER||'.'||PKC.NAME,
PKC.COLUMN_NAME,
PKC.COLUMN_POSITION 
FROM DBA_PART_KEY_COLUMNS PKC, DBA_TABLES T,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
WHERE 
T.OWNER=PKC.OWNER AND T.TABLE_NAME=PKC.NAME
AND t.owner=p.object_owner
and t.table_name=p.object_name
order by 1 desc,2,4
;