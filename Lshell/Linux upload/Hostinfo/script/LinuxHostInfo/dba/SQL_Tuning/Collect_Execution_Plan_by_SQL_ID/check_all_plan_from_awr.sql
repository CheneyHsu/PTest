SELECT  * FROM TABLE(dbms_xplan.display_awr('&&v_sql_id'));