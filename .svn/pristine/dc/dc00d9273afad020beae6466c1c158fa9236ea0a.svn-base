select a.tsname,round(a.total_m,2) total_mb,
round(nvl(b.free_m,0),2) free_mb,
round(nvl((b.free_m/a.total_m)*100,0),2) free_percentage from
(select tablespace_name tsname,sum(bytes)/1024/1024 total_m from dba_data_files group by tablespace_name) a,
(select tablespace_name tsname,sum(bytes)/1024/1024 free_m from dba_free_space group by tablespace_name) b
where a.tsname=b.tsname(+)
--and  a.tsname like 'USERS%'
--and ((b.free_m<5 or b.free_m is null)
--or (b.free_m/a.total_m<0.3 or b.free_m is null))
order by 4 desc;