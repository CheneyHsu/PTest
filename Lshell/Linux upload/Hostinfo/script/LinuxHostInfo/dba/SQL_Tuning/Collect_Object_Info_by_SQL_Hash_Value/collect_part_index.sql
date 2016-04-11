SELECT 
i.owner||'.'||i.index_name,LOCALITY,PARTITIONING_TYPE,
PARTITION_COUNT,SUBPARTITIONING_TYPE,DEF_SUBPARTITION_COUNT 
FROM DBA_PART_INDEXES PI, DBA_INDEXES I,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
WHERE pi.owner=i.owner
and pi.index_name=i.index_name
and i.table_owner=p.object_owner
and i.table_name=p.object_name
order by
1,2,3,4
;