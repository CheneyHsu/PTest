define v_lob_segment_name=&v_lob_segment_name
select /* check lob basic info */
owner,table_name,column_name,segment_name,tablespace_name 
from dba_lobs
where segment_name=upper('&&v_lob_segment_name');