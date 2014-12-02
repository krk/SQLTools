alter database tempdb 
modify file (
	Name = 'tempdev',
	--newname = 'tempdev_8',	
	--filename = 'E:\SQLData\TempDB\tempdev_8.ndf',
	Size = 512MB,
	FILEGROWTH = 512MB,
	MAXSIZE = unlimited
)

alter database tempdb 
add file (
	Name = 'tempdev_8',
	filename = 'T:\MSSQL\Data\tempdev_8.ndf',
	Size = 512MB,
	FILEGROWTH = 512MB,
	MAXSIZE = unlimited
)


declare @sql nvarchar(4000) = '',
		@size int = 4,
		@MaxLogSize int = 24,
		@Step int = 4,
		@MaxFileCount int = 8,
		@CurentFileCount int = 2,
		@FileName nvarchar(4000) 

while @size <= @MaxLogSize  begin
	set @sql =  '	alter database tempdb 
					modify file (
						Name = ''templog'',
						Size = ' + convert(nvarchar(10), @size) + 'GB,
						FILEGROWTH = 512MB,
						MAXSIZE = unlimited
					)'
	exec (@sql)
	set @size += @Step
end


while @CurentFileCount <= @MaxFileCount begin
	set @FileName = 'tempdev_' + convert(nvarchar(4000) , @CurentFileCount) 
	set @sql = 'alter database tempdb 
				add file (
					Name = ' + @FileName + ',
					filename = ''T:\Tempdb\' + @FileName + '.ndf'',
					Size = 4GB,
					filegrowth= 1GB,
					
				)'
				--MAXSIZE = unlimited
	print (@sql)
	set @CurentFileCount += 1
end

select *from tempdb.sys.database_files



