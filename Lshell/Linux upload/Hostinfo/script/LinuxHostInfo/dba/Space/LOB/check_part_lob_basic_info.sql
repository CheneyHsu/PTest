define v_lob_name=&v_lob_name
define v_owner=&v_owner
select /* check partitioned lob basic info */
table_owner,table_name,lob_name,column_name,partition_name,lob_partition_name,tablespace_name 
from dba_lob_partitions 
where LOB_name=uppper('&&v_owner')
and table_owner=upper('&&v_lob_name');