param(
    [Parameter(Mandatory=$false)][string]$rdpPort = "3389"
)

function writeToLog {
param ([string]$message)
$scriptPath = "."
$deploylogfile = "$scriptPath\deploymentlog.log"
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"whhooo Went to test function $message $temptime" | out-file $deploylogfile -Append
}

Process {
 $scriptPath = "."
 $deploylogfile = "$scriptPath\deploymentlog.log"
 if ($PSScriptRoot) {
   $scriptPath = $PSScriptRoot
 } else {
   $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
 }

#Add RDP listening ports if needed
if ($rdpPort -ne 3389) {
    netsh interface portproxy add v4tov4 listenport=$rdpPort connectport=3389 connectaddress=127.0.0.1 
    netsh advfirewall firewall add rule name="Open Port $rdpPort" dir=in action=allow protocol=TCP localport=$rdpPort
}

#Install stuff

$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Installing Visual Studio - $temptime" | out-file $deploylogfile
. $scriptPath\VSCodeSetup-x64-1.32.3.exe /VERYSILENT /MERGETASKS=!runcode
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"After Installing Visual Studio - $temptime" | out-file $deploylogfile -Append
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Installing Chrome - $temptime" | out-file $deploylogfile -Append
. $scriptPath\ChromeStandaloneSetup64.exe /silent /install
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"After Installing Chrome - $temptime" | out-file $deploylogfile -Append
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Installing Git - $temptime" | out-file $deploylogfile -Append
. $scriptPath\Git-2.21.0-64-bit.exe /silent
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"After Installing Git - $temptime" | out-file $deploylogfile -Append
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Installing AZcopy - $temptime" | out-file $deploylogfile -Append
. msiexec.exe /i $scriptPath\MicrosoftAzureStorageAzCopy_netcore_x64.msi /q /log $scriptPath\autoazcopyinstall.log
#add the AZCOPY path to the path variable
$AZCOPYpath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
$actualPath = ((Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path)
$NEWPath =   "$actualPath;$AZCOPYpath"
$NEWPath | Out-File $scriptPath\azcopySystemPath.log
Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $NEWPath
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"After Installing AZcopy - $temptime" | out-file $deploylogfile -Append
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Installing AZ Powershell Module - $temptime" | out-file $deploylogfile -Append
#install Powershell AZ module
Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -force 
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"After Installing AZ Powershell Module - $temptime" | out-file $deploylogfile -Append
#setting the time zone to eastern
& "$env:windir\system32\tzutil.exe" /s "Eastern Standard Time"
writeToLog -message "StefaneMessage"
}
