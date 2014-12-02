select  distinct
		t.name as TableName,
		i.name as IndexName,
		i.is_disabled,
		'drop index ' + i.name + ' on ' + t.name as DropCommand,
		--'alter index ' + i.name + ' on ' + t.name + ' rebuild with (online = on)'
		p.rows
from sys.tables t
	join sys.indexes i on i.object_id = t.object_id
	join sys.partitions p  on p.object_id = t.object_id --and p.index_id = i.index_id
where i.is_disabled = 1
	and i.is_unique = 0
	and i.is_unique_constraint = 0
	and t.type = 'U'
order by p.rows, t.name, i.name