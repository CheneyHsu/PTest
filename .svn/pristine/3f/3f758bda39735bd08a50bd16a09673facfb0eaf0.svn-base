set feedback off
set serverout on
declare
v_owner varchar2(300) :=upper('&&v_owner');
v_segment_name varchar2(300) :=upper('&&v_segment_name');
v_segment_type varchar2(20) :='LOB';
/*  Valid Segment Types:
--   TABLE
--   TABLE PARTITION
--   TABLE SUBPARTITION
--   INDEX
--   INDEX PARTITION
--   INDEX SUBPARTITION
--   CLUSTER
--   LOB
--   LOB PARTITION
--   LOB SUBPARTITION
*/
TOTAL_BLOCKS number;
TOTAL_BYTES number;
UNUSED_BLOCKS number;
UNUSED_BYTES number;
LAST_USED_EXTENT_FILE_ID number;
LAST_USED_EXTENT_BLOCK_ID number;
LAST_USED_BLOCK number;
v_unformatted_blocks number;
v_unformatted_bytes number;
v_fs1_blocks number;
v_fs1_bytes number;
v_fs2_blocks number;
v_fs2_bytes number;
v_fs3_blocks number;
v_fs3_bytes number;
v_fs4_blocks number;
v_fs4_bytes number;
v_full_blocks number;
v_full_bytes number;
begin
dbms_output.put_line('** Space Usage of '||v_segment_type||' Segment: '||v_owner||'.'||v_segment_name);
/* show unused space */
dbms_space.unused_space(v_owner, v_segment_name, v_segment_type,
TOTAL_BLOCKS, TOTAL_BYTES, UNUSED_BLOCKS, UNUSED_BYTES,
LAST_USED_EXTENT_FILE_ID, LAST_USED_EXTENT_BLOCK_ID,
LAST_USED_BLOCK);
dbms_output.put_line('-----------------------------------');
dbms_output.put_line('TOTAL_BLOCKS = '||TOTAL_BLOCKS);
dbms_output.put_line('TOTAL_BYTES = '||TOTAL_BYTES);
dbms_output.put_line('UNUSED_BLOCKS = '||UNUSED_BLOCKS);
dbms_output.put_line('UNUSED BYTES = '||UNUSED_BYTES);
dbms_output.put_line('LAST_USED_EXTENT_FILE_ID = '||LAST_USED_EXTENT_FILE_ID);
dbms_output.put_line('LAST_USED_EXTENT_BLOCK_ID = '||LAST_USED_EXTENT_BLOCK_ID);
dbms_output.put_line('LAST_USED_BLOCK = '||LAST_USED_BLOCK);
/* show blocks internal space */
dbms_space.space_usage (v_owner, v_segment_name, v_segment_type,
v_unformatted_blocks,v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
dbms_output.put_line('-----------------------------------');
dbms_output.put_line('Unformatted Blocks = '||v_unformatted_blocks);
dbms_output.put_line('FS1  0% - 25% Free Blocks = '||v_fs1_blocks);
dbms_output.put_line('FS2 25% - 50% Free Blocks = '||v_fs2_blocks);
dbms_output.put_line('FS3 50% - 75% Free Blocks = '||v_fs3_blocks);
dbms_output.put_line('FS4 75% -100% Free Blocks = '||v_fs4_blocks);
dbms_output.put_line('Full Blocks = '||v_full_blocks);
end;
/
set feedback on