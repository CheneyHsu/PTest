SELECT
PKC.OBJECT_TYPE,
PKC.OWNER||'.'||PKC.NAME,
PKC.COLUMN_NAME,
PKC.COLUMN_POSITION 
FROM DBA_PART_KEY_COLUMNS PKC,DBA_INDEXES I,
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
I.OWNER=PKC.OWNER AND I.INDEX_NAME=PKC.NAME
AND I.TABLE_owner=p.object_owner
and I.TABLE_name=p.object_name
order by 
1 desc,2,4
;