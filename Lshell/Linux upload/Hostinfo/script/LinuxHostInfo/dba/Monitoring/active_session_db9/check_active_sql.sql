set pagesize 999
set linesize 131
col state for a10
col event for a20
col program for a20
col sql_text for a30
col p1to3 for a10
set feed 1

select /* with sql 9i */ 
to_char(s.logon_time,'yyyymmdd hh24:mi:ss'),
p.spid,s.sid,s.username,s.status,s.program,s.last_call_et,
w.event,w.p1,w.p2,w.p3,w.state,w.wait_time,w.seconds_in_wait wait_sec,
s.sql_hash_value,l.sql_text
from v$session s,v$session_wait w,v$process p,v$sql l
where s.type='USER'
and s.sql_hash_value=l.hash_value(+)
and p.addr=s.paddr
and s.sid=w.sid
and s.status='ACTIVE'
--and s.sid=2076
--and p.spid=700636
--and s.program like 'sqlplus%'
order by s.last_call_et;