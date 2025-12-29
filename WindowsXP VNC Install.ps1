<# 
Author - Jared Bakes
Date - 08/18/2025
Purpose - Automtically remove & deploy VNC for Microsoft Windows XP, Server 2003, Vista, Server 2003 R2, Server 2008.
#>


#Library Imports
Import-Module ActiveDirectory

#Get-ADComputer -Filter 'operatingsystem -like "*Windows XP*" -and enabled -eq "true"' -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Sort-Object -Property Operatingsystem | Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address
try{
$WindowsXPObjects = Get-ADComputer -Filter 'operatingsystem -like "*Windows XP*" -and enabled -eq "true"' | Select-Object Name
Write-Host $WindowsXPObjects
}
catch{
Write-Host "An error occurred:"
Write-Host $_
}