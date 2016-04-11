SELECT
OWNER,TABLE_NAME,PARTITIONING_TYPE,SUBPARTITIONING_TYPE,
PARTITION_COUNT,DEF_SUBPARTITION_COUNT 
FROM DBA_PART_TABLES t,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
WHERE t.owner=p.object_owner
and t.table_name=p.object_name
;