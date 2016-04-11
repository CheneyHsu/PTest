SELECT 
i.owner||'.'||i.index_name,LOCALITY,PARTITIONING_TYPE,
PARTITION_COUNT,SUBPARTITIONING_TYPE,DEF_SUBPARTITION_COUNT 
FROM DBA_PART_INDEXES PI, DBA_INDEXES I,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
WHERE pi.owner=i.owner
and pi.index_name=i.index_name
and i.table_owner=p.object_owner
and i.table_name=p.object_name
order by
1,2,3,4
;