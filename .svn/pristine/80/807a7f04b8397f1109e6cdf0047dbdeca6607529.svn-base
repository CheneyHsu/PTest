set pagesize 0;
set line 300;
col systime for a20;
col event for a20;
select to_char(datetime,'yyyymmdd hh24:mi:ss')||'|'||event||'|'||value
  from MINIPACK_DAY_AVG
 where event='log file sync';
--ecifdb1 MINIPACK_DAY_AVG_ECIFDB1
--ecifdb2 MINIPACK_DAY_AVG_ECIFDB2
