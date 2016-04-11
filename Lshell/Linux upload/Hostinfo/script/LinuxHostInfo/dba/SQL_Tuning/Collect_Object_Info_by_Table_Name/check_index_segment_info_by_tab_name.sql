SELECT 
'owner: '||s.owner,
'segment_name: '||s.segment_name,
'segment_type: '||s.segment_type,
'partition_name: '||s.partition_name,
'seg_size_mb: '||s.bytes/1024/1024 seg_info
from dba_segments s,dba_indexes i
where 
i.table_owner='&&v_owner'
and i.table_name='&&v_table_name'
and s.segment_type like 'INDEX%'
and s.segment_name=i.index_name
and s.owner=i.owner
order by 
1,2,4
;