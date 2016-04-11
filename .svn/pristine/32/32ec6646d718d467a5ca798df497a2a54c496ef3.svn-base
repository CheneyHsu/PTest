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
from dba_tab_subpartitions t,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
where table_owner=p.object_owner
and table_name=p.object_name
order by PARTITION_NAME,SUBPARTITION_POSITION
;