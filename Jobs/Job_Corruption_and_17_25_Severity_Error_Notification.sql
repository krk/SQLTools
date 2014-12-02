USE [msdb]
GO

declare @OperatorName sysname = 'SQLReport',
		@SeverityNum int = 17,
		@SeverityName sysname,
		@ErrNum int = 823,
		@ErrName sysname,
		@rmsg varchar(100) = 'Alert: ''%s'' has been created'

--select * from msdb.dbo.sysoperators where name = @OperatorName

--Create alers for severity from 17 to 25
while @SeverityNum <= 25 begin
	
	set @SeverityName = 'Severity 0' + convert(varchar(10), @SeverityNum)

	if not exists (select 1 from msdb.dbo.sysalerts where name = @SeverityName) begin
		exec msdb.dbo.sp_add_alert @name = @SeverityName,
				@message_id = 0,
				@severity = @SeverityNum,
				@enabled = 1,
				@delay_between_responses = 60,
				@include_event_description_in = 1,
				@job_id = N'00000000-0000-0000-0000-000000000000';

		exec msdb.dbo.sp_add_notification 
				@alert_name = @SeverityName, 
				@operator_name = @OperatorName, 
				@notification_method = 7;

		raiserror (@rmsg, 1,0, @SeverityName) with nowait
	end
	
	set @SeverityNum += 1
	
end

--Create corraption alert. Error numbers 823, 824, 825
while @ErrNum <= 825 begin
	
	set @ErrName = 'Error Number ' + convert(varchar(10), @ErrNum)

	if not exists (select 1 from msdb.dbo.sysalerts where name = @ErrName) begin
		exec msdb.dbo.sp_add_alert @name = @ErrName,
				@message_id = @ErrNum,
				@severity = 0,
				@enabled = 1,
				@delay_between_responses = 60,
				@include_event_description_in = 1,
				@job_id = N'00000000-0000-0000-0000-000000000000';

		exec msdb.dbo.sp_add_notification 
				@alert_name = @ErrName, 
				@operator_name = @OperatorName, 
				@notification_method = 7;

		raiserror (@rmsg, 1,0, @ErrName) with nowait
	end
	
	set @ErrNum += 1
	
end

	set @ErrName = 'Login failed'

	if not exists (select 1 from msdb.dbo.sysalerts where name = @ErrName) begin
		exec msdb.dbo.sp_add_alert @name = @ErrName,
				@message_id = 18456,
				@severity = 0,
				@enabled = 1,
				@delay_between_responses = 60,
				@include_event_description_in = 1,
				@job_id = N'00000000-0000-0000-0000-000000000000';

		exec msdb.dbo.sp_add_notification 
				@alert_name = @ErrName, 
				@operator_name = @OperatorName, 
				@notification_method = 7;
		
		raiserror (@rmsg, 1,0, @ErrName) with nowait

	end

	set @ErrName = 'Login disabled'

	if not exists (select 1 from msdb.dbo.sysalerts where name = @ErrName) begin
		exec msdb.dbo.sp_add_alert @name = @ErrName,
				@message_id = 18470,
				@severity = 0,
				@enabled = 1,
				@delay_between_responses = 60,
				@include_event_description_in = 1,
				@job_id = N'00000000-0000-0000-0000-000000000000';

		exec msdb.dbo.sp_add_notification 
				@alert_name = @ErrName, 
				@operator_name = @OperatorName, 
				@notification_method = 7;
		
		raiserror (@rmsg, 1,0, @ErrName) with nowait

	end

	set @ErrName = 'Login failed from untrusted domain'

	if not exists (select 1 from msdb.dbo.sysalerts where name = @ErrName) begin
		exec msdb.dbo.sp_add_alert @name = @ErrName,
				@message_id = 18452,
				@severity = 0,
				@enabled = 1,
				@delay_between_responses = 60,
				@include_event_description_in = 1,
				@job_id = N'00000000-0000-0000-0000-000000000000';

		exec msdb.dbo.sp_add_notification 
				@alert_name = @ErrName, 
				@operator_name = @OperatorName, 
				@notification_method = 7;
		
		raiserror (@rmsg, 1,0, @ErrName) with nowait

	end