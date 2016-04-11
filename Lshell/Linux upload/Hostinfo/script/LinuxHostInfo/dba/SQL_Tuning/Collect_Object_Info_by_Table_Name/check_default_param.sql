select name||' = '||value non_default_param  from v$parameter 
where name like '%optim%' and isdefault='FALSE'
order by 1;