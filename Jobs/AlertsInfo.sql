select	a.name,
		a.event_source,
		a.message_id,
		a.severity,
		a.occurrence_count,
		a.enabled as AlertEnable,
		o.name as Op,
		o.email_address as OpEmail,
		o.enabled as IsOpEnable
		
from msdb..sysalerts a
	left join msdb..sysnotifications n on n.alert_id = a.id
	left join msdb..sysoperators o on o.id = n.operator_id
where o.name = 'ReplicationOperator'
	a.name like 'Replication%'

--For all replication alert set new notification operartor
declare @AlertName sysname,
		@OpName sysname

declare @c cursor
set @c = cursor fast_forward for	
	select	a.name,
			o.name as Op		
	from msdb..sysalerts a
		left join msdb..sysnotifications n on n.alert_id = a.id
		left join msdb..sysoperators o on o.id = n.operator_id
	where a.name like 'Replication%'
		and isnull(o.name,'') != 'ReplicationAlertOperator'
open @C
fetch @c into @AlertName, @OpName

while @@fetch_status = 0 begin
	print @AlertName
	if @OpName is not null 
		exec msdb.dbo.sp_delete_notification
			@alert_name =  @AlertName, 
			@operator_name = @OpName

	exec msdb.dbo.sp_add_notification 
		@alert_name =  @AlertName, 
		@operator_name = 'ReplicationAlertOperator' , 
		@notification_method = 1 --email

	exec msdb.dbo.sp_update_alert 
		@name = @AlertName,
		@enabled = 1

	fetch @c into @AlertName, @OpName
end