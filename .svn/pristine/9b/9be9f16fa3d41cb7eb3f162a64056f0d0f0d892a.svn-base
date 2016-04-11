select 
'owner: '||owner,
'table_name: '||table_name,
'partition_name: '||partition_name,
'column_name: '||column_name,
'num_distinct: '||num_distinct,
'density: '||density,
'num_nulls: '||num_nulls,
'histogram: '||histogram,
'num_buckets: '||num_buckets
from DBA_PART_COL_STATISTICS t,
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
order by owner,table_name,partition_name,column_name
;