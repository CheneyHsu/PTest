--LOG ARCHIVING EFFICTIVE,interval between log archived and reuse less than 5 secs
select b.sequence#,a.blocks*a.block_size/1024/1024 arch_size_mb,
       to_char(a.first_time,'yyyymmdd hh24:mi:ss') Log_First_Use,
       round((a.next_time-a.first_time)*24*3600) Use_sec ,
       round((a.completion_time-a.next_time)*24*3600) archiving_sec ,
       to_char(b.first_time,'yyyymmdd hh24:mi:ss') Log_Re_Use,
              round((b.first_time-a.completion_time)*24*3600) reuse_interval_sec 
  from v$archived_log a,v$archived_log b,(select thread#,count(group#) gn from v$log l group by thread#) rgn
 where a.sequence#+rgn.gn=b.sequence#
  and a.thread#=rgn.thread#
  and a.dest_id=b.dest_id
  and a.thread#=b.thread#
  and a.RESETLOGS_CHANGE#=b.RESETLOGS_CHANGE#    
  and round((b.first_time-a.completion_time)*24*3600)<=5
  and a.first_time>trunc(sysdate)
  and b.first_time>trunc(sysdate)
order by b.first_time;