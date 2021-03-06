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
from DBA_SUBPART_COL_STATISTICS t
where t.owner='&&v_owner'
and t.table_name='&&v_table_name'
order by owner,table_name,subpartition_name,column_name
;