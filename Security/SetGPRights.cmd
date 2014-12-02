rem SQLServer privileges

ntrights.exe +r SeServiceLogonRight -u Domain\SQLServerService -m %1
ntrights.exe +r SeAssignPrimaryTokenPrivilege -u Domain\SQLServerService -m %1
ntrights.exe +r SeChangeNotifyPrivilege -u Domain\SQLServerService -m %1
ntrights.exe +r SeIncreaseQuotaPrivilege -u Domain\SQLServerService -m %1
ntrights.exe +r SeLockMemoryPrivilege -u Domain\SQLServerService -m %1
ntrights.exe +r SeManageVolumePrivilege -u Domain\SQLServerService -m %1

rem SQLServer Agent privileges 

ntrights.exe +r SeServiceLogonRight -u Domain\SQLServerAgent -m %1
ntrights.exe +r SeAssignPrimaryTokenPrivilege -u Domain\SQLServerAgent -m %1
ntrights.exe +r SeChangeNotifyPrivilege -u Domain\SQLServerAgent -m %1
ntrights.exe +r SeIncreaseQuotaPrivilege -u Domain\SQLServerAgent -m %1

pause