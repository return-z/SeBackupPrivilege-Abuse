# SeBackupPrivilege-Abuse
A simple Powershell script that can help you extract the ntds.dit file and the SYSTEM registry hive provided the target user has SeBackupPrivilege (probably a backup operator). I have not coded this from scratch, just collected the code from few different sources.
The script uses [DiskShadow](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/diskshadow) to create a Volume Shadow Copy and extracts the required file from the Shadow Copy. 

## Usage:

Download the script onto the target machine. To abuse the SeBackupPrivilege, you would need these dlls (download them from : https://github.com/giuliano108/SeBackupPrivilege):

* SeBackupPrivilegeUtils.dll

* SeBackupPrivilegeCmdLets.dll

Place the dlls in the same folder as the script. Edit the script for the domain name and the user whose backup privileges you're going to use. 
Now you can run the script.

## Sources:
  * [Dumping Domain Password Hashes](https://pentestlab.blog/tag/ntds-dit/)
  * [Dumping Domain Controller Hashes Locally and Remotely](https://ired.team/offensive-security/credential-access-and-credential-dumping/ntds.dit-enumeration)

