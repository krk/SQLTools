set ansi_nulls on;
set quoted_identifier on;
go
use Adm
go
create view DBList as 
select	F.database_id,
		d.name as DBName,
		F.Name as FileName,
		F.physical_name,
		F.type_desc,
		convert(decimal(12,2), round(F.size * 8. / 1024 / 1024 , 2)) as [FileSize (Gb)],
		d.recovery_model_desc,
		f.growth * 8. / 1024 as FileGrowthMB,
		f.max_size * 8. / 1024 MaxSizeMB,
		f.is_percent_growth,
		d.log_reuse_wait_desc
from sys.master_files f
	join sys.databases d on d.database_id = f.database_id
where f.database_id > 4
go