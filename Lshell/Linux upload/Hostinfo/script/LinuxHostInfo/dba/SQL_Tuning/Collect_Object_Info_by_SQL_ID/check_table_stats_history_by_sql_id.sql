SELECT OWNER||'.'||TABLE_NAME tabname
,TO_CHAR(STATS_UPDATE_TIME,'YYYYMMDD HH24:MI:SS') ana_date
FROM DBA_TAB_STATS_HISTORY T,
(
	select distinct object_owner,object_name from 
	(
		select sql_id,object_type,object_owner,object_name from dba_hist_sql_plan union 
		select sql_id,object_type, object_owner,object_name from v$sql_plan
	)
	where object_type='TABLE'
	and sql_id='&&v_sql_id'
) p 
WHERE TABLE_NAME=p.object_name
AND OWNER=p.object_owner
ORDER BY OWNER,TABLE_NAME,STATS_UPDATE_TIME DESC
;