set pagesize 0;
set line 300;
select p.index_owner||'|'||p.index_name||'|'||p.PARTITION_NAME||'|'||p.SUBPARTITION_NAME 
from dba_ind_subpartitions p,dba_indexes i 
where i.owner=p.index_owner 
  and i.index_name=p.index_name 
  and p.last_analyzed is null 
  and i.index_type!='LOB' 
  and p.index_owner not in ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
                            'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
                            'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN');

