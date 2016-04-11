/** 3. find more information about the session who is holding the lock **/
select /* with sql 10g */ 
p.spid,s.sid,s.serial#,s.username,s.status,s.last_call_et,
to_char(logon_time,'yyyymmdd hh24:mi:ss') logon_time,
s.program,s.machine,s.event,s.p1,s.p2,s.p3,s.state,s.wait_time,s.seconds_in_wait wait_sec,
l.sql_text,nvl(s.sql_id,s.prev_sql_id) sql_id,s.SQL_CHILD_NUMBER
from v$session s, v$process p,v$sqlstats l
where p.addr=s.paddr
and s.status='ACTIVE'
and nvl(s.sql_id,s.prev_sql_id)=l.sql_id(+)
and s.addr='&saddr'
order by s.last_call_et;

