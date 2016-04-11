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
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
where 
ind.owner=i.index_owner
and ind.index_name=i.index_name
and table_owner=p.object_owner
and table_name=p.object_name
order by 
1,2,3,4,SUBPARTITION_NAME
;