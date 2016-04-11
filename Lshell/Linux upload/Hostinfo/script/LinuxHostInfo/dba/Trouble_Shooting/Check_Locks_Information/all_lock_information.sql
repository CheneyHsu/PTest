set serverout on pagesize 999 linesize 180 feed 1 verify off heading on


PRO  ####################  All LOCK Information             ##########
PRO  ####################  " -- " means session in waiting  ##########

col Kill heading 'Sid,Serial# ' format a13 
col lmode heading 'L' format 99 
col request heading 'R' format 99 
col status heading 'Status' for a8
col username  format a10  heading "Lock User" 
col program heading Program format a42 
col Lock_Type format a25
col ctime heading "Seconds"
col lock_id format a20
col sql_text for a80
col event for a20
col state for a15
break on lock_id

SELECT DISTINCT 
  l.id1||'.'||l.id2 lock_id,
  DECODE(L.type,'TM','TM on '||T1.NAME,'TO','TO on '||T1.NAME, L.Type) Lock_Type,
  NVL(S.USERNAME,'Internal') username,
  SUBSTR(NVL(S.PROGRAM,'None'),1,30)||'[' ||s.process||']' program,
  DECODE(l.request,0,NULL,'--')||L.SID||','||S.SERIAL# Kill_string,
  l.lmode,
  l.request,
  l.ctime,
  S.STATUS,
  W.STATE,
  W.EVENT,
  s.last_call_et,
  s.ROW_WAIT_OBJ# waiting_obj_id,
  q.sql_text current_sql
FROM V$LOCK L,
  V$SESSION S,
  V$SESSION_WAIT W,
  SYS.OBJ$ T1,
  v$sqlarea q
WHERE L.SID                                                      = S.SID
AND S.SID                                                        =W.SID
AND T1.OBJ#                                                      = DECODE(L.TYPE,'TM',L.ID1,'TO',L.ID1,10)
AND S.TYPE                                                      != 'BACKGROUND'
AND DECODE(s.sql_hash_value,0,s.prev_hash_value,s.sql_hash_value)=q.hash_value(+)
ORDER BY SUBSTR(lock_type,1,2),
  lock_id,
  ctime DESC;