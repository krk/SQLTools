
select	distinct 
		j.job_id,
		op.name as operator,
		op.email_address,
		case j.notify_level_email	when 0 then 'Never'
									when 1 then 'When the job succeeds'
									when 2 then 'When the job fails'
									when 3 then 'Whenever the job completes'
		end as EmailNotification,
		op.enabled as OperatorEnabled,
		j.name,
		j.enabled as JobEnabled,
		case when s.schedule_id is not null then 1 else 0 end as HasShcedule 
from msdb.dbo.sysjobs j
	left join msdb.dbo.sysjobschedules js on js.job_id = j.job_id
	left join msdb.dbo.sysschedules s on s.schedule_id = js.schedule_id
	left join msdb.dbo.sysoperators op on op.id = j.notify_email_operator_id 

where  j.enabled = 1
order by j.name

exec msdb.dbo.sp_update_job 
	@job_id = 'BD60284A-5912-4C64-BB28-0CDEFEA0D25A',
	@notify_email_operator_name = 'MSXOperator'


exec msdb.dbo.sp_post_msx_operation
	@operation =  'UPDATE',
	@object_type =  'JOB',
	@job_id = 'BD60284A-5912-4C64-BB28-0CDEFEA0D25A',
	@specific_target_server =  'Server'  

exec msdb.dbo.sp_update_operator @Name ='MSXOperator', @email_address = 'sql-backup-job@edomain.tld'



declare @job_id uniqueidentifier
declare @c cursor 
set @c = cursor fast_forward for

	select	distinct j.job_id
		--,j.name
		--,j.notify_level_email
	from msdb.dbo.sysjobs j
		left join msdb.dbo.sysjobschedules js on js.job_id = j.job_id
		left join msdb.dbo.sysschedules s on s.schedule_id = js.schedule_id
		left join msdb.dbo.sysoperators op on op.id = j.notify_email_operator_id 

	where j.enabled = 1

open @c
fetch @c into @job_id
while @@fetch_status = 0 begin
	exec msdb.dbo.sp_update_job 
		@job_id = @job_id,
		@notify_email_operator_name = 'SQLReport',
		@notify_level_email = 2

	fetch @c into @job_id
end 