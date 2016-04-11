set pagesize 0;
set line 400;
col file_name format a80;
select tablespace_name,'||',status,'|',file_name,'|',bytes/1024/1024 bytes  from dba_data_files
union
select tablespace_name,'||',status,'|',file_name,'|',bytes/1024/1024 bytes from dba_temp_files;
