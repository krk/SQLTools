/* Snapshot the current spinlock stats and store so that this can be compared over a time period
Return the statistics between this point in time and the last collection point in time.
**This data is maintained in tempdb so the connection must persist between each execution**
**alternatively this could be modified to use a persisted table in tempdb. if that
is changed code should be included to clean up the table at some point.**
*/
use tempdb
go
declare @current_snap_time datetime
declare @previous_snap_time datetime

set @current_snap_time = GETDATE()
if not exists(select name from tempdb.sys.sysobjects where name like '#_spin_waits%')

create table #_spin_waits
(
	lock_name varchar(128)
	,collisions bigint
	,spins bigint
	,sleep_time bigint
	,backoffs bigint
	,snap_time datetime
)
--capture the current stats
insert into #_spin_waits
(
	lock_name
	,collisions
	,spins
	,sleep_time
	,backoffs
	,snap_time
)
select name
	,collisions
	,spins
	,sleep_time
	,backoffs
	,@current_snap_time
	from sys.dm_os_spinlock_stats

select top 1 @previous_snap_time = snap_time from #_spin_waits
where snap_time < (select max(snap_time) from #_spin_waits)
order by snap_time desc
--get delta in the spin locks stats
select top 10

spins_current.lock_name
, (spins_current.collisions - spins_previous.collisions) as collisions
, (spins_current.spins - spins_previous.spins) as spins
, (spins_current.sleep_time - spins_previous.sleep_time) as sleep_time
, (spins_current.backoffs - spins_previous.backoffs) as backoffs
, spins_previous.snap_time as [start_time]
, spins_current.snap_time as [end_time]
, DATEDIFF(ss, @previous_snap_time, @current_snap_time) as [seconds_in_sample]
from #_spin_waits spins_current
inner join (
select * from #_spin_waits
where snap_time = @previous_snap_time
) spins_previous on (spins_previous.lock_name = spins_current.lock_name)
where
spins_current.snap_time = @current_snap_time
and spins_previous.snap_time = @previous_snap_time
and spins_current.spins > 0
order by (spins_current.spins - spins_previous.spins) desc
--clean up table
delete from #_spin_waits
where snap_time = @previous_snap_time