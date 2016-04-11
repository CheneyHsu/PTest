set pagesize 0;
set line 300;
select owner||'|'||object_type||'|'||object_name||'|'||to_char(last_ddl_time,'yyyymmdd hh24:mi')
from dba_objects
 where owner!='SYS' and status!='VALID';

