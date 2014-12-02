select *, datediff (ss, StartTime, EndTime)
from adm.dbo.CommandLog with(nolock) 
where datediff (ss, StartTime, EndTime) > 100
order by ID desc
