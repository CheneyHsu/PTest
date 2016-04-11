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
from dba_indexes i
where 
table_owner='&&v_owner'
and table_name='&&v_table_name'
order by
1,2,3,4
;