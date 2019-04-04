param(
    [Parameter(Mandatory=$false)][string]$rdpPort = "3389"
)

Process {
 $scriptPath = "."

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
. $scriptPath\VSCodeSetup-x64-1.32.3.exe /VERYSILENT /MERGETASKS=!runcode

}
