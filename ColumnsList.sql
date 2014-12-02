select	t.Name as TableName,
		c.name as ColumnName
from sys.tables t
	join sys.columns c on c.object_id = t.Object_id
where 
	c.name like '%sequent%'
order by T.Name, C.name

