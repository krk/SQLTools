
--Server permissions
select	 *
from (
	select	--prm.class_desc,
			--prm.type,
			prm.permission_name,
			--prm.state_desc,
			pr.name as LoginName,
			pr.is_disabled
	from sys.server_permissions prm
		left join sys.server_principals pr on pr.principal_id = prm.grantee_principal_id 
) p
pivot (
	count(p.permission_name) 
	for p.permission_name in ([ALTER ANY AVAILABILITY GROUP],[AUTHENTICATE SERVER],[CONNECT],[CONNECT SQL],[CONTROL SERVER],[VIEW ANY DATABASE],[VIEW ANY DEFINITION],[VIEW SERVER STATE])
) as Pvt
order by pvt.LoginName

--Server role membership
select	 *
from (
	select	sp.name as RoleName, 
			m.name as MemberName
	from sys.server_principals sp
		left join sys.server_role_members rm on rm.role_principal_id = sp.principal_id
		left join sys.server_principals m on m.principal_id = rm.member_principal_id
	where --sp.type = 'R'
		--and m.name is not null
		--and 
		m.name like 'domain\user'
		or m.name like 'domain\user2'
) p
pivot (
	count(p.RoleName) 
	for p.RoleName in ([sysadmin],[securityadmin],[serveradmin],[setupadmin],[processadmin],[diskadmin],[dbcreator],[bulkadmin])
) as Pvt
order by pvt.MemberName


select *
from sys.server_principals sp
	join sys.server_permissions pp on pp.grantee_principal_id = sp.principal_id
where sp.type != 'U'
order by sp.name

SELECT	--rm.role_principal_id, 
		r.name as RoleName, 
		--rm.member_principal_id, 
		m.name as MemberName
FROM sys.server_role_members rm
	left JOIN sys.server_principals r ON rm.role_principal_id = r.principal_id
	left JOIN sys.server_principals m ON rm.member_principal_id = m.principal_id



select *
from sys.database_role_members rm
	join sys.database_principals dp on dp.owning_principal_id = 