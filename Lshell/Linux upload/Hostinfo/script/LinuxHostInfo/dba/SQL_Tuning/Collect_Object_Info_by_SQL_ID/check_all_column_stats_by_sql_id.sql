select 
'owner: '||owner,
'table_name: '||table_name,
'column_id: '||column_id,
'column_name: '||column_name,
'data_type: '||data_type, 
'num_distinct: '||num_distinct,
'density: '||density,
'num_nulls: '||num_nulls,
'histogram: '||histogram,
'num_buckets: '||num_buckets
from dba_tab_columns t,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
where t.owner=p.object_owner
and t.table_name=p.object_name
order by owner,table_name,column_id
;