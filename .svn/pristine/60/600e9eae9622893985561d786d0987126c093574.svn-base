select position||'.'||name||'('||DATATYPE_STRING||') : "'||value_string||'"' 
from v$sql_bind_capture 
where sql_id='&&v_sql_id'
order by 1; 