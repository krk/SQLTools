select	--'alter index ' + i.name + ' on ' + t.name + ' rebuild with (pad_index = on, fillfactor = 90)',
		--'update statistics ' + t.name, 
		db_name(db_id()) as DatabaseName,
		TableName = t.name,
		IndexName = i.name,
		lob = case when c.object_id is null then 0 else 1 end,
		IndexType = i.type_desc,
		s.alloc_unit_type_desc,
		avg_fragmentation_in_percent = round(s.avg_fragmentation_in_percent, 0),
		s.fragment_count,
		s.avg_fragment_size_in_pages,
		s.page_count,
		s.index_depth,
		i.fill_factor,
		p.rows		
from sys.dm_db_index_physical_stats(db_id(), null, null, null, null) s 
	join sys.tables t with(nolock) on t.object_id = s.object_id and t.type_desc = 'user_table'
	join sys.indexes i with(nolock) on i.object_id = s.object_id and i.index_id = s.index_id
	join sys.partitions p with(nolock) on p.object_id = t.object_id  and p.index_id = i.index_id
	left join sys.columns c with(nolock) on c.object_id = t.object_id and ((c.system_type_id in (34, 99,35,241, 165)) or (c.system_type_id in(167, 231) and c.max_length = -1))
where	
		s.avg_fragmentation_in_percent > 0
		--and s.page_count >= 1000
		--i.fill_factor <> 0
		and i.type_desc != 'heap'
		and p.rows > 1000
order by round(s.avg_fragmentation_in_percent, 0)  desc, s.fragment_count
--order by p.rows desc


