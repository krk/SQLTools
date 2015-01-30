set ansi_nulls on;
set quoted_identifier on;
go

use Adm
go

if object_id('dbo.CreateBackup') is null exec ('create procedure dbo.CreateBackup as begin return end')
go
alter procedure dbo.CreateBackup 
	@Type varchar(100),
	@db_list varchar(8000),	
	@PathToShare sysname
as 
begin

	if isnull(@db_list, '') = '' 
		raiserror('Database list is emtpy.', 17, 1);
	
	if isnull(@PathToShare , '') = '' 
		raiserror('Path to share is emtpy.', 17, 1);

	set @PathToShare += case when right(@PathToShare, 1) != '\' then '\' else '' end;

	declare @db_name sysname,
			@ServerName sysname = replace(@@ServerName,'\','_'),
			@Backup_path sysname,
			@pos int;
	
	declare @T table(Name varchar(8000))

	while len(@db_list) > 1 begin
		set @pos = charindex('|', @db_list)
		set @db_name = left(@db_list, case when @pos > 0 then @pos - 1 else len(@db_list) end)
	
		insert @T (Name) values (@db_name)
		set @db_list = replace(@db_list, @db_name  + case when @pos > 0 then  '|' else '' end,'' )
	end

	declare @c cursor
	set @c = cursor fast_forward for 
		select d.name
		from @T T	
			join sys.databases d on d.name = T.Name
	open @c
	fetch @c into @db_name  

	if @Type = 'full' begin
		while @@fetch_status = 0 begin
			set @Backup_path =	@PathToShare + @ServerName + case when @db_name in ('master','model', 'msdb') then '\System\' else '\' end +
								@ServerName + '_' + @db_name + '_' + replace(convert(varchar(100), getdate(), 111), '/', '-') + '_' +
								replace(convert(varchar(100), getdate(), 108), ':', '-') + '.full'

			raiserror (@db_name, 10, 1) with nowait
			raiserror (@backup_path, 10, 1) with nowait
		
			backup database @db_name
			to disk = @Backup_path
			with checksum, compression, retaindays = 30, nounload, norewind --, stats = 10 --copy_only, 

			fetch @c into @db_name 
		end
	end

	if @Type = 'diff' begin
		while @@fetch_status = 0 begin
			set @Backup_path =	@PathToShare + @ServerName + '\' + 
								@ServerName + '_' + @db_name + '_' + replace(convert(varchar(100), getdate(), 111), '/', '-') + '_' +
								replace(convert(varchar(100), getdate(), 108), ':', '-') + '.diff'

			raiserror (@db_name, 10, 1) with nowait
			raiserror (@backup_path, 10, 1) with nowait
		
			backup database @db_name
			to	disk = @Backup_path	
			with checksum, compression, retaindays = 14, differential, nounload, norewind

			fetch @c into @db_name 
		end
	end

	if @Type = 'log' begin
		--File name format: <Server>_<database>_YYY-MM-DD_multifile.tlog One file per day.
		while @@fetch_status = 0 begin
			set @Backup_path =	@PathToShare + @ServerName + '\' + 
								@ServerName + '_' + @db_name + '_' + replace(convert(varchar(100), getdate(), 111), '/', '-') + '_multifile' +'.tlog'
			raiserror (@db_name, 10, 1) with nowait
			raiserror (@backup_path, 10, 1) with nowait
		
			backup log @db_name
			to disk = @Backup_path
			with checksum, compression, retaindays = 2, nounload, norewind

			fetch @c into @db_name 
		end
	end

	close @c
	deallocate @c

end
go
