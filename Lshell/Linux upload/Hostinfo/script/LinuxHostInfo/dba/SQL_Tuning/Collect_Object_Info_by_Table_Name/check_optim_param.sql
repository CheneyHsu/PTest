select name||' = '||value all_optim_param from v$parameter 
where name like '%optim%' 
or name in ('db_file_multiblock_read_count','pga_aggregate_target')
order by 1;