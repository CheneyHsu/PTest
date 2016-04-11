set pagesize 0;
set line 300;
select owner||'|'||table_name 
  from dba_tables 
 where last_analyzed is null 
   and  owner not in ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
                      'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
                      'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN');

