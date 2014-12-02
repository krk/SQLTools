select	session_id,
		convert(decimal(12,2), round(s.user_objects_alloc_page_count * 8.  / 1024  ,2)) as user_objects_alloc_page_count,
		convert(decimal(12,2), round(s.user_objects_dealloc_page_count * 8.  / 1024  ,2)) as user_objects_dealloc_page_count,
		convert(decimal(12,2), round(s.internal_objects_alloc_page_count * 8.  / 1024  ,2)) as internal_objects_alloc_page_count,
		convert(decimal(12,2), round(s.internal_objects_dealloc_page_count * 8.  / 1024  ,2)) as internal_objects_dealloc_page_count,
		convert(decimal(12,2), round((s.internal_objects_dealloc_page_count  +
										s.internal_objects_alloc_page_count +
										s.user_objects_dealloc_page_count +
										s.user_objects_alloc_page_count )
		
		* 8.  / 1024  ,2)) as TotalMB

from sys.dm_db_session_space_usage s
where session_id > 50
	and (s.internal_objects_dealloc_page_count  +
			s.internal_objects_alloc_page_count +
			s.user_objects_dealloc_page_count +
			s.user_objects_alloc_page_count) > 0
order by TotalMB desc