param([Parameter(Mandatory=$false)][string]$OfficeVersion = "Office2016")

Process {
 $scriptPath = "."

 if ($PSScriptRoot) {
   $scriptPath = $PSScriptRoot
 } else {
   $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
 }

#Importing all required functions
. $scriptPath\VSCodeSetup-x64-1.32.3.exe /VERYSILENT /MERGETASKS=!runcode

}