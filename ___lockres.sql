select *, 
	f.%%lockres%%, 
	%%physloc%%, 
	sys.fn_PhysLocFormatter (%%physloc%%) AS RID,
	%%rowdump%%
from master..spt_values f
	--join sys.dm_tran_locks l on l.resource_description = f.%%lockres%%
dbcc traceon (3604)
dbcc page(6,1,78,3)


declare @T table (ID int)

insert @T values (1)
select *, 
	f.%%lockres%%, 
	%%physloc%%, 
	sys.fn_PhysLocFormatter (%%physloc%%) AS RID,
	%%rowdump%%
from @T F