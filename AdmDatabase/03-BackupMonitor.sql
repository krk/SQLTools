set ansi_nulls on;
set quoted_identifier on;
go
use adm 
go
  
if object_id('dbo.BackupMonitor') is null exec ('create procedure dbo.BackupMonitor as begin return end')
go
alter procedure dbo.BackupMonitor
as begin

	select	session_id, 
			command, 
			a.text as Query, 
			start_time, 
			percent_complete, 
			dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time 
	from sys.dm_exec_requests r 
		cross apply sys.dm_exec_sql_text(r.sql_handle) a 
	where r.command like 'BACKUP%' 
		or r.command like 'RESTORE%'
	
end
go