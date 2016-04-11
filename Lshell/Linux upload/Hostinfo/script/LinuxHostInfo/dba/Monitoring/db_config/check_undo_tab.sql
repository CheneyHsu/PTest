select t.tablespace_name,sum(f.bytes)/1024/1024 
from dba_tablespaces t,dba_data_files f
where t.tablespace_name=f.tablespace_name
and t.contents='UNDO'
group by t.tablespace_name;
select tablespace_name,status,sum(bytes)/1024/1024 from dba_undo_extents
group by tablespace_name,status;