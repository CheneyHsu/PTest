select 
table_owner||'.'||table_name||','||index_owner||'.'||index_name||','||column_position||'.'||column_name
from dba_ind_columns i,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
where i.table_name=p.object_name 
and i.table_owner=p.object_owner
order by table_owner,table_name,index_owner,index_name,column_position;