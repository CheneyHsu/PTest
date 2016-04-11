select 
table_owner||'.'||table_name||','||index_owner||'.'||index_name||','||column_position||'.'||column_name
from dba_ind_columns
where table_owner='&&v_owner'
and table_name='&&v_table_name'
order by table_owner,table_name,index_owner,index_name,column_position
;