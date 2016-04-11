select 
'table_owner: '||ind.table_owner,
'table_name: '||ind.table_name,
'owner: '||ind.owner,
'index_name: '||ind.index_name,
'uniqueness: '||ind.uniqueness,
'index_type: '||ind.index_type,
'partition_position: '||partition_position,
'partition_name: '||partition_name,
'subpartition_count: '||subpartition_count,
'blevel: '||i.blevel,
'leaf_blocks: '||i.leaf_blocks,
'clustering_factor: '||i.clustering_factor,
'last_ana: '||to_char(i.last_analyzed,'yyyymmdd hh24:mi:ss') last_ana 
from dba_indexes ind,dba_ind_partitions i
where 
ind.owner=i.index_owner
and ind.index_name=i.index_name
and table_owner='&&v_owner'
and table_name='&&v_table_name'
order by 
1,2,3,4,PARTITION_POSITION
;