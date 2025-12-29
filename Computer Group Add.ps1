$computerList = @()
$computerList = Get-ADComputer -Filter 'operatingsystem -like "*Windows Embedded*" -and enabled -eq "true"' -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,DistinguishedName  |
Sort-Object -Property Operatingsystem | Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,DistinguishedName 
for ($i = 0; $i -lt $computerList.Length; $i++) {
        Write-Host $computerList[$i]
        $currentPC = $computerList[$i].DistinguishedName
        Add-ADGroupMember "Win Embedded Mfg" -members $currentPC
    }