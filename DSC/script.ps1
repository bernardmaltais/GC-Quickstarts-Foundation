param([Parameter(Mandatory=$false)][string]$OfficeVersion = "Office2016")

Process {
 $scriptPath = "."

 if ($PSScriptRoot) {
   $scriptPath = $PSScriptRoot
 } else {
   $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
 }

#Add RDP listening ports
netsh interface portproxy add v4tov4 listenport=33890 connectport=3389 connectaddress=127.0.0.1 
netsh advfirewall firewall add rule name="Open Port 33890" dir=in action=allow protocol=TCP localport=33890

#Importing all required functions
. $scriptPath\VSCodeSetup-x64-1.32.3.exe /VERYSILENT /MERGETASKS=!runcode

}