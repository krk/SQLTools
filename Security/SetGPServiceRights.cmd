rem SQLServer privileges

ntrights.exe +r SeServiceLogonRight -u %1 -m %2
ntrights.exe +r SeAssignPrimaryTokenPrivilege -u %1 -m %2
ntrights.exe +r SeChangeNotifyPrivilege -u %1 -m %2
ntrights.exe +r SeIncreaseQuotaPrivilege -u %1 -m %2
ntrights.exe +r SeLockMemoryPrivilege -u %1 -m %2
ntrights.exe +r SeManageVolumePrivilege -u %1 -m %2

pause