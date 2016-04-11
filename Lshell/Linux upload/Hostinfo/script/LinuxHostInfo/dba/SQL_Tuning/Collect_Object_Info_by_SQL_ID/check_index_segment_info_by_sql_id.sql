SELECT 
'owner: '||s.owner,
'segment_name: '||s.segment_name,
'segment_type: '||s.segment_type,
'partition_name: '||s.partition_name,
'seg_size_mb: '||s.bytes/1024/1024 seg_info
from dba_segments s,dba_indexes i,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p
where 
i.table_owner=p.object_owner
and i.table_name=p.object_name
and s.segment_type like 'INDEX%'
and s.segment_name=i.index_name
and s.owner=i.owner
order by 
1,2,4
;