define v_table_owner=&v_table_owner
define v_table_name=&v_table_name
select  /* check partitioned lob seg info */
l.column_name LOB_COLNAME,l.lob_name lob_seg_name,l.lob_partition_name,sl.bytes/1024/1024 lob_bytes_mb,sl.blocks lob_blocks
from dba_lob_partitions l,dba_segments sl
where l.lob_name=sl.segment_name
and l.lob_partition_name=sl.partition_name
and l.table_owner=sl.owner
and l.table_owner=upper('&&v_table_owner')
and l.table_name=upper('&&v_table_name');