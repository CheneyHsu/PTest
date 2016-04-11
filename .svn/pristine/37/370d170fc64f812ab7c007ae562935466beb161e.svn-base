select /*+ NO_MERGE */ a.*,a.limit_value-a.max_utilization FREE_SPACE 
from 
(select * from v$resource_limit where limit_value!=' UNLIMITED') a 
order by free_space desc;