select 
'owner: '||owner,
'table_name: '||table_name,
'blocks: '||blocks,
'degree: '||degree,
'num_rows: '||num_rows,
'sample_size: '||sample_size,
'parted : '||partitioned,
'temped: '||temporary,
'last_ana: '||to_char(last_analyzed,'yyyymmdd hh24:mi:ss') table_info 
from dba_tables t,
(	select distinct o.object_type,o.owner object_owner,o.object_name from v$sql_plan l,dba_objects o 
  where l.object#=o.object_id 
    and hash_value=&&v_sql_hash_value 
    and o.object_type='TABLE'	
	) p  
where t.table_name=p.object_name 
and t.owner=p.object_owner
order by 1,2;