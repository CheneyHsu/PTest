select 
'owner: '||table_owner,
'table_name: '||table_name,
'partition_name: '||partition_name,
'subposition: '||subpartition_position,
'subpart_name: '||subpartition_name,
'blocks: '||blocks,
'num_rows: '||num_rows,
'sample_size: '||sample_size,
'last_ana: '||to_char(last_analyzed,'yyyymmdd hh24:mi:ss') table_part_info ,
high_value
from dba_tab_subpartitions
where table_owner='&&v_owner'
and table_name='&&v_table_name'
order by PARTITION_NAME,SUBPARTITION_POSITION
;