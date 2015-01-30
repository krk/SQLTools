select	distinct 
		t.name,
		p.rows,
		'EXEC sp_estimate_data_compression_savings ''dbo'', '''+t.name+''', NULL, NULL, ''ROW'' ;', 
		'ALTER TABLE dbo.'+t.name + ' REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE); '
from sys.tables t
	join sys.partitions p on p.object_id = t.object_id
where 	index_id =1
	and t.name = 'tablename'
order by p.rows desc


