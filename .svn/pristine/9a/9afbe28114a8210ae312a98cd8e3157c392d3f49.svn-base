SELECT plan_hash_value,max(cost) max_cost,min(cost) max_cost 
FROM V$SQL_PLAN 
WHERE depth=0 
AND hash_value='&&v_sql_hash_value'
group by sql_id, plan_hash_value
order by sql_id,plan_hash_value
;