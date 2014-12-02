select *
from sys.dm_tran_active_transactions
where transaction_id = 14957396072


select db_name(database_id ), *
from sys.dm_tran_database_transactions
where database_id = db_id()
	and transaction_id = 14957396072

select	s.session_id,
		*
from sys.dm_tran_locks tl
	join sys.dm_exec_sessions s on s.session_id = tl.request_session_id --and s.session_id = 93
	--join sys.dm_os_memory_objects mo on mo.memory_object_address = tl.lock_owner_address
where tl.resource_database_id = db_id()
--	and tl.
--	and transaction_id = 14957396072



select	at.transaction_id,	
		st.session_id,
		at.name,
		at.transaction_begin_time,
		datediff(ms, at.transaction_begin_time, getdate()) as Duration,
		at.transaction_type,
		st.enlist_count,
		st.is_user_transaction,
		st.is_local,
		st.open_transaction_count,
		st.is_bound
from sys.dm_tran_active_transactions at 
	join sys.dm_tran_session_transactions st on st.transaction_id = at.transaction_id
where at.transaction_id = 14957396072		
select * from sys.dm_tran_database_transactions where transaction_id = 2590238273
select * from sys.dm_tran_session_transactions where transaction_id = 14957396072

select *
from sys.dm_tran_commit_table