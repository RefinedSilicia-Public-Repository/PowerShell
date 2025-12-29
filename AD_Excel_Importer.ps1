# Import the Excel file
$excelFile = Import-Excel -Path "C:\Data\EmployeeInformation.xlsx" -WorksheetName "Sheet1"

for ($i=0;$i -lt $excelFile.Count; $i++){

$row = $excelFile[$i];
$employeeIDVar=$row.employeeid
$buildingVar=$row.building
$usernameVar=$row.username
$firstNameVar=$row.first

Write-Host "$employeeIDVar`n$buildingVar`n$usernameVar`n$firstnameVar`n"

$currentUser=Get-ADUser -Identity $usernameVar
Write-Host "Current User Is: $currentUser`n"
$currentUserADUsername=$currentUser.SamAccountName
Write-Host "Current AD UserName Targeted: $currentUserADUsername`n"
#Locate Row of Matching SAM Account and Excel Row
if($usernameVar -eq $currentUserADUsername ){
Set-ADUser -Identity $currentUserADUsername -Replace @{physicalDeliveryOfficeName="$buildingVar"}
}
Write-Host "The BuildVar Being Written Is: $buildingVar`n"
Write-Host "Break`n"
}

