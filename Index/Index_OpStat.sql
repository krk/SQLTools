select	t.name as TableName,
		i.name as IndexName,
		p.rows,
		os.*
from sys.dm_db_index_operational_stats(db_id(), null,null,null) os 
	join sys.indexes i with(nolock)  on i.object_id = os.object_id and i.index_id = os.index_id
	join sys.tables t with(nolock)  on t.object_id = os.object_id
	join sys.partitions p with(nolock) on p.object_id = t.object_id and p.index_id = i.index_id 
where --page_lock_wait_in_ms > 0
	tree_page_io_latch_wait_count > 0
order by tree_page_io_latch_wait_count desc
order by page_lock_wait_in_ms desc
order by lob_fetch_in_pages desc
order by t.name, i.name