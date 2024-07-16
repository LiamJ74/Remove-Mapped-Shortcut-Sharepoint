
The purpose of this PowerShell script is to remove all SharePoint shortcuts a user has set on their professional OneDrive (when they click on "Add shortcut to OneDrive" instead of clicking the Sync button), through Intune, GPO, or manually.

The script will check if there is an occurrence of the REGZ "IsFolderScope" with a value of 1 in this registry path: "HKCU:\Software\SyncEngines\Providers\OneDrive". If yes, it will check the path in the REGZ "MountPoint" value and finally delete the folder.

The final goal for system administrators is to push, after this script, a correct, ISO-compliant SharePoint Folder Sync and not let the user create shortcuts directly in their OneDrive.

You can disable the "Add shortcut to OneDrive" button on SharePoint with these commands: 

```powershell
# Connect to SharePoint Online
Connect-SPOService "https://crescent-admin.sharepoint.com"
 
# Disable "Add Shortcut to OneDrive"
Set-SPOTenant -DisableAddShortCutsToOneDrive $True
```
If you want to push SharePoint Library Folder directly through Intune, see:

1. [Configure auto sign-in and sync for OneDrive with Intune](https://mrshannon.wordpress.com/2020/07/20/configure-auto-sign-in-and-sync-for-onedrive-with-intune/)

2. [Create ODopen link to sync SharePoint Library](https://fabozzi.net/create-odopen-link-to-sync-sharepoint-library/)

Here the powershell command if you already know how to find SyncID : 

```powershell
#>
param(
[String]$siteid = "%7XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&",
[String]$webid = "%7XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&",
[String]$listid = "%7XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&",
[String]$URL = "https"%7XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&",
[String]$webtitle = "XXXXXXXXXX",
[String]$listtitle = "XXXXXXXXXX"
)

$rand = Get-Random -Maximum 10
sleep $rand
#Sleep is required, if the same script runs at the same time it'll mess up the configuration.
$Version = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseID | Select-Object ReleaseID
if($version.releaseID -lt 1709) { break }

$UPN = whoami /upn

$path = "$($env:profile)\OneDrive - $($listtitle)"
if(Test-Path $path){
#DoNothing
} else {
start "odopen://sync/?siteId=$siteid&webId=$webid&listId=$listid&userEmail=$upn&webUrl=$URL&webtitle=$webtitle&listtitle=$listtitle"
}
```

Thanks for the sources.
