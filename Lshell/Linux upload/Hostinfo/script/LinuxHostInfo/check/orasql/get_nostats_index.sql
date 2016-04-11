set pagesize 0;
set line 300;

select owner||'|'||index_name||'|'||index_type  
  from dba_indexes
 where last_analyzed is null 
   and index_type!='LOB' 
   and  owner not in ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
                      'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
                      'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN');




