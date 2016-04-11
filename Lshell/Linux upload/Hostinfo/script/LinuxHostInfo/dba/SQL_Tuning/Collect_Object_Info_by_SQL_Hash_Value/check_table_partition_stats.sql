select 
'owner: '||table_owner,
'table_name: '||table_name,
'partition_position: '||partition_position,
'partition_name: '||partition_name,
'composite: '||composite,
'blocks: '||blocks,
'num_rows: '||num_rows,
'sample_size: '||sample_size,
'last_ana: '||to_char(last_analyzed,'yyyymmdd hh24:mi:ss') table_part_info ,
high_value
from dba_tab_partitions t,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p
where table_owner=p.object_owner
and table_name=p.object_name
order by PARTITION_POSITION
;