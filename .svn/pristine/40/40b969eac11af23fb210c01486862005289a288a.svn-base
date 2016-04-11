SELECT
PKC.OBJECT_TYPE,
PKC.OWNER||'.'||PKC.NAME,
PKC.COLUMN_NAME,
PKC.COLUMN_POSITION 
FROM DBA_PART_KEY_COLUMNS PKC, DBA_TABLES T,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
WHERE 
T.OWNER=PKC.OWNER AND T.TABLE_NAME=PKC.NAME
AND t.owner=p.object_owner
and t.table_name=p.object_name
order by 1 desc,2,4
;