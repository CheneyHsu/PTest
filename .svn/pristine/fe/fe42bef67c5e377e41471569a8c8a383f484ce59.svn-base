SELECT
OWNER,TABLE_NAME,PARTITIONING_TYPE,SUBPARTITIONING_TYPE,
PARTITION_COUNT,DEF_SUBPARTITION_COUNT 
FROM DBA_PART_TABLES t,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
WHERE t.owner=p.object_owner
and t.table_name=p.object_name;