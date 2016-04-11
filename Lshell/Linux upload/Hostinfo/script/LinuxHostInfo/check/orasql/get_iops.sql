set pagesize 0;
set line 300;
col snap_time for a20;
col value format a10;
select to_char(END_INTERVAL_TIME,'yyyymmdd hh24:mi:ss')||'|'||sp.snap_id||'|'||round((n.value-p.value)/1000000)
  from sys.wrh$_sysstat p,
       sys.wrh$_sysstat n,
       sys.wrh$_stat_name nm,
       sys.wrm$_snapshot sp,
       v$instance i
 where n.dbid=p.dbid and n.instance_number=p.instance_number
   and i.instance_number=p.instance_number
   and n.snap_id=sp.snap_id
   and n.snap_id=p.snap_id+1
   and p.stat_id=n.stat_id
   and p.stat_id=nm.stat_id
   and p.instance_number=n.instance_number
   and p.dbid=nm.dbid
   and n.value>p.value
   and nm.stat_name='physical write total bytes'
   and sp.instance_number=p.instance_number
   and to_char(END_INTERVAL_TIME,'yyyymmdd hh24:mi:ss')<to_char(sysdate,'yyyymmdd')||' 06:10:00' 
   and to_char(END_INTERVAL_TIME,'yyyymmdd hh24:mi:ss')>to_char(sysdate-1,'yyyymmdd')||' 06:10:00' 
order by sp.snap_id;
