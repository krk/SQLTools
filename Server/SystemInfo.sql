select cpu_count AS [Logical CPU Count], 
		hyperthread_ratio AS [Hyperthread Ratio],
		cpu_count/hyperthread_ratio AS [Physical CPU Count], 
		convert(decimal(12, 0), round(physical_memory_kb * 1. / 1024 / 1024,0 )) AS [Physical Memory (Gb)], 
		affinity_type_desc, 
		virtual_machine_type_desc, 
		sqlserver_start_time,
		@@version as [Version]
from sys.dm_os_sys_info with(nolock)


select cpu_count AS [Logical CPU Count], 
		hyperthread_ratio AS [Hyperthread Ratio],
		cpu_count/hyperthread_ratio AS [Physical CPU Count], 
		convert(decimal(12, 0), round(physical_memory_in_bytes * 1. / 1024 / 1024 / 1024,0 )) AS [Physical Memory (Gb)], 
		affinity_type_desc, 
		virtual_machine_type_desc, 
		sqlserver_start_time,
		@@version as [Version]
from sys.dm_os_sys_info with(nolock)
