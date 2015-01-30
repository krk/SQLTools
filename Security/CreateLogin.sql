--Create login

create login [domain\user] from windows;
create login [login] with password ='p4$$W0rd', CHECK_EXPIRATION = off, CHECK_POLICY = off


--Create user in database
use DB
create user [login] for login [login];

--Add role

--2012 and above
alter role <role> add member [login]

--2008
exec sp_addrolemember 'role', 'login'

--restore sql user
exec sp_change_users_login  'Update_One', 'dbuser', 'dbuser'


--Generate script for several databases

declare @Login sysname = '[login]',
		@role sysname = 'role'
select name, 'use ' + name + '; create user ' + @login +' for login '+ @login + '; alter role ' + @role +  ' add member ' + @Login
from sys.databases 
where state_desc = 'ONLINE'
	and name not in ('master', 'tempdb', 'model', 'msdb', 'distribution', 'ReportServer', 'ReportServerTempDB' )

