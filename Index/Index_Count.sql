select	t.name,
		count(i.name) as IndexCount,
		cc.ColCount
from sys.tables t 
		join sys.indexes i on i.object_id = t.object_id and i.type_desc != 'heap'
		cross apply (	select count(c.column_id) as ColCount
						from sys.columns c 
						where c.object_id = t.object_id) cc
where indexproperty(i.object_id, i.name, 'IsDisabled') = 0
group by	t.name,
			cc.ColCount
having count(i.name) > 4
	and count(i.name) * 1. / cc.ColCount > 0.7
order by 2 desc