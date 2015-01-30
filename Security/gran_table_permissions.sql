declare @Login sysname = '[domain\user]'

select 
'grant update on object::' + s.name + '.' + t.name + ' to ' + @Login + ';' + char(13) +
'grant insert on object::' + s.name + '.' + t.name + ' to ' + @Login + ';' + char(13) +
'grant delete on object::' + s.name + '.' + t.name + ' to ' + @Login

from sys.tables t
	join sys.schemas s on s.schema_id = t.schema_id
where t.name like '%TableName%'

