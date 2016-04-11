SELECT sql_id, plan_hash_value,max(cost) max_cost,min(cost) max_cost 
FROM dba_hist_sql_plan 
WHERE depth=0 
AND sql_id='&&v_sql_id'
group by sql_id, plan_hash_value
order by sql_id,plan_hash_value
;