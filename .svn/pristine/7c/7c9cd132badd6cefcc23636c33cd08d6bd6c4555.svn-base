/********  to check which row causes lock contention **********/
select program,machine,
nvl(o.object_name,'The LOCK is NOT on TABLE rows (likely on INDEX)') table_name,
l.sql_text locking_sql, 
case substr(o.object_type,1,5) when 'TABLE' then
'select * from '||owner||'.'||o.object_name||' where rowid=DBMS_ROWID.ROWID_CREATE (1,'||O.data_object_id||','||ROW_WAIT_FILE#||','||ROW_WAIT_BLOCK#||','||ROW_WAIT_ROW#||');' 
else
nvl(o.object_type,'Can NOT find lock records on non-Table objects') 
end find_lock_record
from v$session s,v$sqlstats l,dba_objects o
where event like 'enq: TX - row lock contention'
and s.state='WAITING'
and s.sql_id=l.sql_id(+)
and s.ROW_WAIT_OBJ#=o.object_id(+)
;
