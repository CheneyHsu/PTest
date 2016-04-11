set serverout on
set verify off

declare
sleep_time number :=10;
cursor c1 is 
with a as
(
	select distinct sql_id,object_type, object_owner,object_name,OBJECT#  from v$sql_plan
	where sql_id='&&v_sql_id' and object# is not null
)
select 
a.object_owner||'.'||a.object_name||decode(o.subobject_name,null,null,'( '||o.subobject_name||' )') objname,
a.object# objid,
s.dataobj# dobjid,
s.statistic_name statname,
s.value,
sysdate
from v$segstat s,
     dba_objects o,
     a
where s.statistic_name in ('logical reads')
and a.object_owner=o.owner
and a.object_name=o.object_name
and s.obj#=o.object_id
and s.dataobj#=o.data_object_id
order by 4,1,2,3
;
type stat_wait is record ( objname varchar2(200),
                           objid   number,
                           dobjid number,
                           statname varchar2(200),
                           count    number,
                           snaptime date
                          );
type stat_wait_tab is table of stat_wait index by pls_integer;
pre_tab stat_wait_tab;
nex_tab stat_wait_tab;

j number :=1;

begin

open c1;
fetch c1 BULK COLLECT into pre_tab;
close c1;
           
dbms_lock.sleep(sleep_time);

open c1;
fetch c1 BULK COLLECT into nex_tab;
close c1;


j:=pre_tab.first;

--dbms_output.put_line(to_char(pre_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')||' -- '|| to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss'));

for i in nex_tab.first .. nex_tab.last loop

if pre_tab(j).objname=nex_tab(i).objname 
   and pre_tab(j).objid=nex_tab(i).objid 
   and pre_tab(j).dobjid=nex_tab(i).dobjid then

    if nex_tab(i).count-pre_tab(j).count>0 then
     dbms_output.put(to_char(nex_tab(i).snaptime,'yyyy-mm-dd hh24:mi:ss')||'# ');
     dbms_output.put_line(nex_tab(i).objname||'  '||nex_tab(i).statname||'(/sec): '||round((nex_tab(i).count-pre_tab(j).count)/(nex_tab(i).snaptime-pre_tab(j).snaptime)/86400));
    end if;  
    j:=j+1;

else
    if nex_tab(i).count>0 then
     dbms_output.put(to_char(nex_tab(i).snaptime,'yyyy-mm-dd hh24:mi:ss')||'# ');
     dbms_output.put_line(nex_tab(i).objname||'  '||nex_tab(i).statname||'(/sec): '||round((nex_tab(i).count-0)/(nex_tab(i).snaptime-pre_tab(j).snaptime)/86400));
    end if;  

end if;

end loop;

end;
/