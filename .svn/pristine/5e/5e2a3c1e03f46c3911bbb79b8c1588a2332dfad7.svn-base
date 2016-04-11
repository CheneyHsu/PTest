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
from dba_tables
where owner='&&v_owner'
and table_name='&&v_table_name'
;