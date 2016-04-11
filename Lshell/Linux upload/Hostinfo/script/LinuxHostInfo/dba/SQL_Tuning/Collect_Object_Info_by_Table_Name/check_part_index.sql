SELECT 
i.owner||'.'||i.index_name,LOCALITY,PARTITIONING_TYPE,
PARTITION_COUNT,SUBPARTITIONING_TYPE,DEF_SUBPARTITION_COUNT 
FROM DBA_PART_INDEXES PI, DBA_INDEXES I
WHERE pi.owner=i.owner
and pi.index_name=i.index_name
and i.table_owner='&&v_owner'
and i.table_name='&&v_table_name'
order by
1,2,3,4
;