select 
'table_owner: '||ind.table_owner,
'table_name: '||ind.table_name,
'owner: '||ind.owner,
'index_name: '||ind.index_name,
'uniqueness: '||ind.uniqueness,
'index_type: '||ind.index_type,
'subpartition_position: '||subpartition_position,
'subpartition_name: '||subpartition_name,
'blevel: '||i.blevel,
'leaf_blocks: '||i.leaf_blocks,
'clustering_factor: '||i.clustering_factor,
'last_ana: '||to_char(i.last_analyzed,'yyyymmdd hh24:mi:ss') last_ana 
from dba_indexes ind,dba_ind_subpartitions i,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
where 
ind.owner=i.index_owner
and ind.index_name=i.index_name
and table_owner=p.object_owner
and table_name=p.object_name
order by 
1,2,3,4,SUBPARTITION_NAME
;