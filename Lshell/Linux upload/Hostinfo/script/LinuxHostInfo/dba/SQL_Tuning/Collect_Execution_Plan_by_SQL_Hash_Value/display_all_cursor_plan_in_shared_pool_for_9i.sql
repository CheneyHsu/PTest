define v_sql_hash_value=&v_sql_hash_value
select 
lpad(' ',depth*2)||operation||' '||options||'  '
||decode(object_owner,null,null,object_owner||'.'||object_name)
||'(Optimizer: '||optimizer||')' 
||'(Cost: '||cost||')' 
||'(Card: '||cardinality||')'
||'(Bytes: '||bytes||')'
||'(Filter: '||filter_predicates||')'
||'.'||'(Access: '||access_predicates||')'
||'(part_start: '||partition_start||')'
||'(part_stop: '||partition_stop||')'
||'(part_id: '||partition_id||')'  sql_plan
from v$sql_plan
where 
hash_value=&&v_sql_hash_value
order by plan_hash_value,child_number,id
;