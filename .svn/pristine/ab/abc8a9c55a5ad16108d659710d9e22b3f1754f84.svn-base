select to_char(sysdate,'yyyymmdd hh24:mi:ss')||'|'||a.RESOURCE_NAME||'|'||a.CURRENT_UTILIZATION||'|'||MAX_UTILIZATION||'|'||trim(a.limit_value)||'|'||round(MAX_UTILIZATION/(limit_value+1),2)*100
  from v$resource_limit a
 where limit_value!='UNLIMITED' and limit_value!='0'
   and RESOURCE_NAME in('processes','sessions');


