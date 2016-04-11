col c1 heading 'Program|Name'         format a30
col c2 heading 'PGA|Used|Memory'      format 999,999,999
col c3 heading 'PGA|Allocated|Memory' format 999,999,999
col c4 heading 'PGA|Maximum|Memory'   format 999,999,999
col username forma a10
select
a.program c1,a.username,b.pga_used_mem c2,b.pga_alloc_mem c3,b.pga_max_mem c4
from
v$session a,v$process b
where a.paddr=b.addr
order by
c4 desc;