select  s.volume_mount_point,
		convert(decimal(12,2), round(s.total_bytes * 1. / 1024 / 1024 / 1024, 2)) as [Total (Gb)],
		convert(decimal(12,2), round(s.available_bytes * 1. / 1024 / 1024 / 1024, 2)) as [Free (Gb)],
		convert(decimal(12,2), round(s.available_bytes * 1. / (s.total_bytes / 100) ,2)) as [Free %]
from sys.master_files f 
	cross apply sys.dm_os_volume_stats(f.database_id, f.file_id) s
group by s.volume_mount_point,
		s.total_bytes,
		s.available_bytes
order by 1, 2

