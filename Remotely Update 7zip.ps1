<#
.SYNOPSIS
This is a simple Powershell script to install and update 7-Zip from official sources silently
.DESCRIPTION
The script will download based on the detected architecture of the host and the channel selected the newest version it can find from the 7-Zip official static releases. 
.EXAMPLE
Update-7Zip.ps1
Update 7-Zip using the default parameters in which it will download the latest released version based on automatically detecting your host systems architecture
.EXAMPLE
Update-7Zip.ps1 -Architecture 32
Update or install 7-Zip using the stable release channel and instead of auto detection of the architecture it will download the 32 bit version
.EXAMPLE
Update-7Zip.ps1 -Architecture 64
Update or install 7-Zip using the stable release channel and instead of auto detection of the architecture it will download the 64 bit version
.EXAMPLE
Update-7Zip.ps1 -Show
Using the Show parameter it will show you the Setup screen for 7-Zip instead of installing silently
.LINK
https://www.7-zip.org/
https://perplexity.nl/
#>
[CmdletBinding()]
param
(
    [Parameter()][ValidateSet('64', '32', 'Detect')][string]$Architecture = "Detect",
    [Parameter()][string]$TemporaryDownloadFolder = "C:\Users\" + $($env:username) + "\AppData\Local\Temp\7Zip\",
    [Parameter()][Switch]$Show
)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Declares
$7zipWebsite = 'https://7-zip.org/'
$TemporaryDownloadFile = $TemporaryDownloadFolder + "7zip.exe" 
#Detect Architecture
if ($Architecture -eq 'Detect')
{
    Write-Verbose "Detecting host operating system architecture to download according version of 7-Zip"
    if ([Environment]::Is64BitOperatingSystem)
    {
        $Architecture = '64'
    }
    else 
    {
        $Architecture = '32'
    }
}
#Check if a temp folder exist if so recreate it
Write-Verbose "Creating temporary work directory in $TemporaryDownloadFolder"
if (-Not(Test-Path $TemporaryDownloadFolder))
{
    New-Item -Path $TemporaryDownloadFolder -ItemType Directory | Out-Null
}
#Check if a temp download exists if so delete it and redownload it
Write-Verbose "Checking if a download already exists if so remove it"
if(Test-Path $TemporaryDownloadFile)
{
    Remove-Item $TemporaryDownloadFile
}
#Based on the Architecture selected or detected request what the newest version of 7-zip is
Write-Verbose "Requested the download url of the newest 7-Zip version available based on selected architecture $Architecture bit"
if ($Architecture -eq 64)
{
    $webLocation = $7zipWebsite + (Invoke-WebRequest -Uri $7zipWebsite | Select-Object -ExpandProperty Links | Where-Object {($_.innerHTML -eq 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -ExpandProperty href).Split(' ')[0]
}
else
{
    $webLocation = $7zipWebsite + (Invoke-WebRequest -Uri $7zipWebsite | Select-Object -ExpandProperty Links | Where-Object {($_.innerHTML -eq 'Download') -and ($_.href -like "a/*") -and ($_.href -notlike "*-x64.exe")} | Select-Object -ExpandProperty href).Split(' ')[0]
}
#Downloading based on the 
Write-Verbose "Start the download of $weblocation to $TemporaryDownloadFile"
Invoke-WebRequest $webLocation -OutFile $TemporaryDownloadFile
Write-Verbose "Installing the downloaded 7-Zip version"
if ($Show)
{
    Start-Process $TemporaryDownloadFile -Wait
}
else 
{ 
    Start-Process $TemporaryDownloadFile -ArgumentList "/S" -Wait
}
Write-Verbose "Cleaning up the temporary work directory that was used"
Remove-Item $TemporaryDownloadFolder -Recurse -Force
Write-Verbose "Script has been completed"