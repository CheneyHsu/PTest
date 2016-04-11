define v_sql_hash_value=&v_sql_hash_value 
select sql_text from v$sqltext where hash_value=&&v_sql_hash_value order by piece;