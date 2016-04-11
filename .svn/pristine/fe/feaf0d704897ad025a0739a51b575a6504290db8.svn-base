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
from dba_tab_columns t
where t.owner='&&v_owner'
and t.table_name='&&v_table_name'
order by owner,table_name,column_id
;