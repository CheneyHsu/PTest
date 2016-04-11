set pagesize 0;
set line 300;
col NAME format a40;
col VALUE format a60;
col DISPLAY_VALUE format a60;
select name,'|',type,'|',value,'|',display_value from  v$parameter;
