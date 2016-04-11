select 
'owner: '||owner,
'table_name: '||table_name,
'subpart_name: '||subpartition_name,
'column_name: '||column_name,
'num_distinct: '||num_distinct,
'density: '||density,
'num_nulls: '||num_nulls,
'histogram: '||histogram,
'num_buckets: '||num_buckets
from DBA_SUBPART_COL_STATISTICS t,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
where t.owner=p.object_owner
and t.table_name=p.object_name
order by owner,table_name,subpartition_name,column_name
;