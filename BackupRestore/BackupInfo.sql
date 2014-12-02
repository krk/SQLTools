select	distinct
		f.logical_name,
		f.file_type,
		s.type,
		f.file_size / 1024. / 1024 / 1024 as [File Size GB],
		f.backup_size / 1024. / 1024 / 1024 as [Backup Size GB],
		m.physical_device_name,
		s.position,
		s.backup_start_date,
		s.backup_finish_date,
		datediff(ss, s.backup_start_date,s.backup_finish_date) as [Duration (Seconds)]
from msdb..backupfile f
		join msdb..backupset s on s.backup_set_id = f.backup_set_id
		join msdb..backupmediafamily m on m.media_set_id = s.media_set_id
where s.backup_start_date > getdate() -14
order by s.backup_finish_date desc

