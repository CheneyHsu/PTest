set pagesize 0;
select systime||'|'||active_undosize||'|'||total_undosize||'|'||active_pct
  from (
select to_char(sysdate,'yyyymmdd hh24:mi:ss') systime,
       round(nvl(sum(b.bytes/1024/1024),0)) active_undosize,
       tbs_size total_undosize,
       round(nvl(sum(b.bytes/1024/1024),0)/tbs_size*100) active_pct
  from (select tablespace_name,round(sum(bytes/1024/1024)) tbs_size from dba_data_files group by tablespace_name) a,
       dba_undo_extents b,v$parameter c
 where a.tablespace_name=b.tablespace_name
   and a.tablespace_name=c.value
   and c.name='undo_tablespace'
 group by tbs_size);
