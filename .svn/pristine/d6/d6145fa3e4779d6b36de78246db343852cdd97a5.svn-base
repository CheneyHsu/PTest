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
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p 
where t.table_name=p.object_name 
and t.owner=p.object_owner
order by owner,table_name
;