
exec sp_configure 'show advanced options', 1
exec sp_configure 'backup compression default', 1
exec sp_configure 'remote admin connections', 1
exec sp_configure 'max server memory (MB)', 24576
exec sp_configure 'min server memory (MB)', 1024
exec sp_configure 'max degree of parallelism',  8
exec sp_configure 'cost threshold for parallelism', 1000
exec sp_configure 'fill factor (%)', 95
exec sp_configure 'optimize for ad hoc workloads', 1
exec sp_configure 'Ole Automation Procedures', 1
exec sp_configure 'access check cache quota', 50000
exec sp_configure 'access check cache bucket count', 0
exec sp_configure 'remote proc trans', 1
exec sp_configure 'blocked process threshold (s)', 0
exec sp_configure 'clr enabled', 1
exec sp_configure 'xp_cmdshell', 0 
exec sp_configure  'scan for startup procs', 1
reconfigure	

select *
from sys.configurations
where name like '%remote proc trans%'



