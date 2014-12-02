
restore database  DB
from disk = '<path_to_full>_2014-05-05_00-09-34.full'  
with file = 1,
	move 'data' to 'D:\SQLData\Data_20140408_1000.mdf',
	move 'log' to 'L:\SQLLog\Log_20140408_1000_log.ldf',	
	STATS = 2,			
	checksum,	
	norecovery,
	replace

RESTORE FILELISTONLY FROM  DISK =  'path_to_full'
RESTORE HEADERONLY FROM  DISK = 'path_to_tlog'

declare @n tinyint = 1,
		@maxChunk int = 91

while @n <= @maxChunk begin
	restore log DB
	from disk = 'path_to_multifile.tlog'
	with file = @n,
		stats = 10,
		norecovery,
		checksum,
		stopat = '2014-02-17 14:10:00.000'

	print char(13) + ' ============ Log #' + convert(varchar(10), @n) + ' / ' + convert(varchar(10), @maxChunk) + ' has been restored ============' + char(13)

	set @n += 1	
end


restore database DB with recovery

