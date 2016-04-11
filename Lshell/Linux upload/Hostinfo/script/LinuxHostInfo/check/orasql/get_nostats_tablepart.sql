set pagesize 0;
set line 300;
select table_owner||'|'||table_name||'|'||partition_name 
  from dba_tab_partitions 
 where last_analyzed is null 
   and table_owner not in ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
                           'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
                           'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN');
