$PCList = (Get-ADComputer -Filter {OperatingSystem -notlike "*SERVER*" -and Enabled -EQ $True}).Name
[Array]::Sort($PCList)
$ExportVar = ForEach ($PC in $PCList){
	Try{$User = (Get-WMIObject Win32_ComputerSystem -ComputerName $PC -ErrorAction Stop).UserName.split('\')[-1]}
	Catch {$User = "Problem with $($PC)."; $Failures += "$($PC)`n"; Continue}

	[PSCustomObject] @{
		"Computer" = $PC
		"Logged-in User" = $User
		}  # End PSCustomObject
}
Write-Warning "These ones failed:`n"
$Failures
$ExportVar | Export-Csv C:\Stuff.csv