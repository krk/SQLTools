select	fk.name, 
		Parent = OBJECT_NAME(fk.parent_object_id),
		ParentColumn = pc.name,
		Referenced = OBJECT_NAME(fk.referenced_object_id),
		--fk.key_index_id, 		
		ReferencedColumn = rc.name,
		ForeignKeyCount = count(fk.name)
from sys.foreign_keys fk	
	join sys.foreign_key_columns fkc on fkc.parent_object_id = fk.parent_object_id and fk.referenced_object_id = fkc.referenced_object_id
	join sys.columns pc on pc.column_id = fkc.parent_column_id and pc.object_id = fk.parent_object_id
	join sys.columns rc on rc.column_id = fkc.referenced_column_id and rc.object_id = fk.referenced_object_id
--where fk.key_index_id > 1
group by	fk.parent_object_id, 
			fk.referenced_object_id,
			pc.name,
			rc.name,
			fk.name
--having count(fk.name) = 2
order by OBJECT_NAME(fk.parent_object_id), pc.name, OBJECT_NAME(fk.referenced_object_id), rc.name
