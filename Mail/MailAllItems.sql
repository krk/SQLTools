--Find out mail send errors

select top 10 sent_status, *
from msdb.dbo.sysmail_allitems
order by 2 desc

select top 10 *
from msdb.dbo.sysmail_event_log
order by 1 desc