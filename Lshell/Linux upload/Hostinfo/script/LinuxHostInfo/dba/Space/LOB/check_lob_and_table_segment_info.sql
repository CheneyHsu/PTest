define v_owner=&v_owner
define v_table_name=&v_table_name
select /* check lob and table segment info */
t.table_name,st.bytes/1024/1024 table_bytes_mb,st.blocks tab_blocks,
l.column_name LOB_COLNAME,l.segment_name,sl.bytes/1024/1024 lob_bytes_mb,sl.blocks lob_blocks
from dba_tables t,dba_lobs l,dba_segments st,dba_segments sl
where t.table_name=l.table_name
and t.owner=l.owner
and t.table_name=st.segment_name
and t.owner=st.owner
and l.segment_name=sl.segment_name
and l.owner=sl.owner
and t.owner=upper('&&v_owner')
and t.table_name=upper('&&v_table_name');