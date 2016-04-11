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
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p 
where i.table_name=p.object_name 
and i.owner=p.object_owner
order by
1,2,3,4;