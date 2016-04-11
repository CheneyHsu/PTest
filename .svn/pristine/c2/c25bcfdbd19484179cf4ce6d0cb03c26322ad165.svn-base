select name||' = '||value hidden_param from v$parameter 
where name like '\_%' escape '\'
and name not in (
'_enable_NUMA_optimization',
'_db_block_numa',
'_gc_undo_affinity',
'_gc_affinity_time',
'_undo_autotune',
'_cursor_features_enabled')
order by 1;