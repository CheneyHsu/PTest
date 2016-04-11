SELECT 
'owner: '||s.owner,
'segment_name: '||s.segment_name,
'segment_type: '||s.segment_type,
'partition_name: '||s.partition_name,
'seg_size_mb: '||s.bytes/1024/1024 seg_info
from dba_segments s
where 
s.owner='&&v_owner'
and s.segment_type like 'TABLE%'
and s.segment_name='&&v_table_name'
order by 
1,2,4
;