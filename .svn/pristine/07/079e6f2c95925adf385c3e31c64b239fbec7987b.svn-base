set pagesize 999
set linesize 131
col state for a10
col event for a20
col program for a20
col sql_text for a30
col p1to3 for a10
set feed 1

alter session set nls_date_format='yyyymmdd hh24:mi:ss';

select /* with sql 10g */ 
p.spid,s.sid,s.username,s.status,
s.program,s.last_call_et,
s.event,s.p1,s.p2,s.p3,
s.state,s.wait_time,s.seconds_in_wait wait_sec,
l.sql_text,l.sql_id,s.SQL_CHILD_NUMBER
from v$session s, v$process p,v$sqlstats l
where s.type='USER'
and p.addr=s.paddr
and s.status='ACTIVE'
and s.sql_id=l.sql_id(+)
--and s.prev_sql_id=l.sql_id(+)
--and s.program like 'sqlplus%'
--and s.sid =3191
--and p.spid=700636
order by s.last_call_et;