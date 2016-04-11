SELECT 
'owner: '||s.owner,
'segment_name: '||s.segment_name,
'segment_type: '||s.segment_type,
'partition_name: '||s.partition_name,
'seg_size_mb: '||s.bytes/1024/1024 seg_info
from dba_segments s,dba_indexes i,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
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