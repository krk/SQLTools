select	distinct	
		--db_name(s.database_id), 
		s.login_name,
		convert(datetime, convert(int, s.login_time)) as login_time,
		s.host_name, 
		s.last_request_start_time,
		s.last_request_end_time,
		s.program_name,
		c.auth_scheme,
		'kill ' + convert(varchar(10),s.session_id)
from sys.dm_exec_connections c 
	left join sys.dm_exec_sessions s on s.session_id = c.session_id

order by s.last_request_start_time desc


