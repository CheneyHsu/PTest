SELECT
  t.*
FROM
  v$sql s,
  TABLE(dbms_xplan.display_cursor(s.sql_id,s.child_number)) t
WHERE
  s.sql_id = '&&v_sql_id';