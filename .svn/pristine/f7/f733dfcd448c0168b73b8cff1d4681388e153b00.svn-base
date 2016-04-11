define v_table_owner=&v_table_owner
define v_table_name=&v_table_name
select  /* check partitioned lob and tab part info */
t.table_name,t.partition_name,st.bytes/1024/1024 table_bytes_mb,st.blocks tab_blocks,
l.column_name LOB_COLNAME,l.lob_name lob_seg_name,l.lob_partition_name,sl.bytes/1024/1024 lob_bytes_mb,sl.blocks lob_blocks
from dba_tab_partitions t,dba_lob_partitions l,dba_segments st,dba_segments sl
where t.table_name=l.table_name
and t.table_owner=l.table_owner
and t.partition_name=l.partition_name
and t.table_name=st.segment_name
and t.table_owner=st.owner
and t.partition_name=st.partition_name
and l.lob_name=sl.segment_name
and l.lob_partition_name=sl.partition_name
and l.table_owner=sl.owner
and t.table_owner=upper('&&v_table_owner')
and t.table_name=upper('&&v_table_name');