
select	r.session_id,
		r.database_id,
		db_name(r.database_id) as DBName,
		r.percent_complete,
		s.login_name,
		s.host_name,
		s.login_time,
		r.blocking_session_id,
		r.status,
		r.command,
		r.wait_type,
		r.wait_time,
		r.last_wait_type,
		r.wait_resource,
		r.open_transaction_count,
		r.scheduler_id,
		convert(decimal(12,2), round(r.granted_query_memory * 1. * 8 / 1024, 2)) as [Granted memory in MB],
		u.internal_objects_alloc_page_count,
		u.internal_objects_dealloc_page_count,
		u.user_objects_alloc_page_count,
		u.user_objects_dealloc_page_count,
		r.plan_handle,
		r.sql_handle,
		p.query_plan,
		t.text as SQLText
		
from sys.dm_exec_requests r with(nolock)
	left join sys.dm_exec_sessions s with(nolock) on s.session_id = r.session_id
	left join sys.dm_db_session_space_usage u with(nolock) on u.session_id = s.security_id
	outer apply sys.dm_exec_query_plan(r.plan_handle) p	
	outer apply sys.dm_exec_sql_text(r.sql_handle) t 

where r.session_id > 50
order by session_id

--dbcc freeproccache(0x05000700DD03B56A40A198A9060000000000000000000000)




