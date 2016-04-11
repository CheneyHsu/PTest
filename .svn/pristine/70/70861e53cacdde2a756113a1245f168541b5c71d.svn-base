define v_owner=&v_owner
define v_table_name=&v_table_name
select /* check lob segment info */
l.column_name LOB_COLNAME,l.segment_name,sl.bytes/1024/1024 lob_bytes_mb,sl.blocks lob_blocks
from dba_lobs l,dba_segments sl
where l.segment_name=sl.segment_name
and l.owner=sl.owner
and l.owner=upper('&&v_owner')
and l.table_name=upper('&&v_table_name');