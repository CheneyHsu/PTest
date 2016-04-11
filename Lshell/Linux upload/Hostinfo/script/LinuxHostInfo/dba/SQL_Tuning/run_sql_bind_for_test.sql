/***********************************************************************/
/******************* 6.gen sql bind value for test   *******************/
/***********************************************************************/

set sqlblanklines on
set trimspool on
set trimout on
set feedback off;
set linesize 255;
set pagesize 50000;
set timing off;
set head off;
SET VERIFY OFF;
set showmode off;
col sql_text for a255 wrap
--
accept sql_id char prompt "Enter SQL ID ==> "
accept child_no char prompt "Enter Child Number ==> " default 0
var isdigits number
--
--
col sql_fulltext for a255 word_wrap
spool &&sql_id
--
--Check for numeric bind variable names
--
begin
--select case regexp_substr(replace(name,':',''),'[[:digit:]]') when replace(name,':','') then 1 end into :isdigits
select case when ascii(substr(replace(name,':',''),1,1)) between 48 and 57 then 1 end  into :isdigits
from
V$SQL_BIND_CAPTURE
where
sql_id='&&sql_id'
and child_number = &&child_no
and rownum < 2;
end;
/
--
-- Create variable statements
--
select
'variable ' ||
   case :isdigits when 1 then replace(name,':','N') else substr(name,2,30) end || ' ' ||
replace(datatype_string,'CHAR(','VARCHAR2(') txt
from
V$SQL_BIND_CAPTURE
where
sql_id='&&sql_id'
and child_number = &&child_no;
--
-- Set variable values from V$SQL_BIND_CAPTURE
--
select 'begin' txt from dual;
select
   case :isdigits when 1 then replace(name,':',':N') else name end ||
   ' := ' ||
   case datatype_string when 'NUMBER' then null else '''' end ||
   value_string ||
   case datatype_string when 'NUMBER' then null else '''' end ||
   ';' txt
from
   V$SQL_BIND_CAPTURE
where
   sql_id='&&sql_id'
   and child_number = &&child_no;
select 'end;' txt from dual;
select '/' txt from dual;
--
-- Generate statement
--
select regexp_replace(sql_fulltext,'(select |SELECT )','select /* test &&sql_id */ ',1,1) sql_fulltext from (
select case :isdigits when 1 then replace(sql_fulltext,':',':N') else sql_fulltext end ||';' sql_fulltext
from v$sqlarea
where sql_id = '&&sql_id');
--
--select
--replace(sql_fulltext,':',':N') sql_fulltest
--from v$sql s
--where
--sql_text not like '%from v$sql where sql_text like nvl(%'
--and sql_id like nvl('&sql_id',sql_id);
--select ';' txt from dual;
spool off;
undef sql_id
undef child_no
set feedback on;
set head on