select 
'table_owner: '||i.table_owner,
'table_name: '||i.table_name,
'owner: '||i.owner,
'index_name: '||i.index_name,
'uniqueness: '||uniqueness,
'index_type: '||index_type,
'partitioned: '||partitioned,
'degree: '||degree,
'blevel: '||blevel,
'leaf_blocks: '||leaf_blocks,
'clustering_factor: '||clustering_factor,
'last_ana: '||to_char(last_analyzed,'yyyymmdd hh24:mi:ss') last_ana 
from dba_indexes i,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p 
where i.table_name=p.object_name 
and i.owner=p.object_owner
order by
1,2,3,4
;