select 
table_owner||'.'||table_name||','||index_owner||'.'||index_name||','||column_position||'.'||column_name
from dba_ind_columns i,
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
and i.table_owner=p.object_owner
order by table_owner,table_name,index_owner,index_name,column_position
;