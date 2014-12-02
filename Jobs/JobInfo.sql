select	--ts.Server_name,
		j.name,
		suser_sname(j.owner_sid),
		j.enabled,
		j.description,
		c.name as Category,
		case j.notify_level_email	when 0 then 'Never'
									when 1 then 'When the job succeeds'
									when 2 then 'When the job fails'
									when 3 then 'Whenever the job completes'
		end as EmailNotification,
		op.name,
		op.email_address,
		js.next_run_date,
		js.next_run_time,
		s.name as ScheduleName,
		s.freq_interval,
		jsrv.last_outcome_message
from msdb.dbo.sysjobs j
	join msdb.dbo.syscategories c on c.category_id = j.category_id 
		left join msdb.dbo.sysjobschedules js on js.job_id = j.job_id
		left join msdb.dbo.sysschedules s on s.schedule_id = js.schedule_id
	left join msdb.dbo.sysoperators op on op.id = j.notify_email_operator_id and op.enabled = 1
	left join msdb.dbo.sysjobservers jsrv on jsrv.job_id = j.job_id 
	left join msdb.dbo.systargetservers ts on ts.server_id = jsrv.server_id
where j.enabled = 1
order by j.name

--select *
--from msdb.dbo.sysjobsteps js
--where js.database_user_name like '%Каширова%'


--select *
--from sys.linked_logins
--where remote_name like '%Каширова%'

--select name, is_disabled
--from sys.server_principals
--where name like '%Каширова%'


