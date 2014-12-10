declare @name sysname,
		@sql nvarchar(4000)

declare @R table (DatabaseName sysname, VLFCount int)
declare @T table (FileID int, FileSize bigint, StartOffset bigint, FSeqNo int, Status tinyint, Parity tinyint, CreateLSN varchar(8000))

declare @c cursor
set @c = cursor fast_forward for 
	select name
	from sys.databases
	where state_desc = 'ONLINE'
	 
open @c
fetch @c into @name

while @@fetch_status = 0 begin
	set @sql = 'use ' + @name + '; DBCC LOGINFO;'
	insert @T 
	exec (@sql)

	insert @R (DatabaseName, VLFCount)
	select @Name, count(*)
	from @T
		
	fetch  @c into @name
end
close @c
deallocate @c

select *
from @R 
order by DatabaseName
