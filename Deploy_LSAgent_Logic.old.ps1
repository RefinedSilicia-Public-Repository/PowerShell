#Published Date - 12/4/2025
#Developer - Jared Bakes
#Purpose - Controls to deploy LsAgent Version 12.2.0.1 32-Bit to all client PC's in AD

$LogFile = "\\pssrv\CorpForum\Logs\Deploy_LSAgent_Logic.log"

function WriteLog
{
Param ([string]$LogString)
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$LogMessage = "$Stamp $LogString"
Add-content $LogFile -value $LogMessage -Encoding UTF8
}

#Declare Variable for default LsAgent Location
$rootFolder = 'C:\Program Files (x86)\LansweeperAgent'
#Delcare variables necessary from endpoint
$ComputerNameString = Get-ComputerInfo | Select "CsName"
$OSVersionString = Get-ComputerInfo | Select "OsVersion"
$OSVersionStringReduced = $OSVersionString -replace "[^0-9.\s]",""

switch -Wildcard ($OSVersionStringReduced){
#Windows 2008R2 - 2012, 7, 8
"6.*" {
    #Check if the file path already exists on endpoint
    if (-not (Test-Path -Path $rootFolder)){
    #Calls Sysvol on domain controller to deploy exe
    Start-Process -FilePath "\\corp.sgstool.com\SYSVOL\corp.sgstool.com\exe\LsAgent-windows_12.2.0.1.exe" -ArgumentList ' --server Lansweeper.corp.sgstool.com --port 9524 --agentkey ece3aac3-fc25-4ba2-a318-a8ef69d6966e --mode unattended'
    WriteLog "Script 6.* launched executable on $ComputerNameString"
    }
    Else{
        WriteLog "Script 6.* did not write to $ComputerNameString due to Lansweeper already installed."
    }
}
#Windows 10, 11
"10.*" {
    #Check if the file path already exists on endpoint
    if (-not (Test-Path -Path $rootFolder)){
    #Calls Sysvol on domain controller to deploy exe
    Start-Process -FilePath "\\corp.sgstool.com\SYSVOL\corp.sgstool.com\exe\LsAgent-windows_12.2.0.1.exe" -ArgumentList ' --server Lansweeper.corp.sgstool.com --port 9524 --agentkey ece3aac3-fc25-4ba2-a318-a8ef69d6966e --mode unattended'
    WriteLog "Script 10.* launched executable on $ComputerNameString"
    }
    Else{
        WriteLog "Script 10.* did not write to $ComputerNameString due to Lansweeper already installed."
    }
}
default {
   WriteLog "No Matches Found for $OSVersionStringReduced skipping machine $ComputerNameString"
    }
}
