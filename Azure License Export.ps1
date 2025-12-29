#Import-Module Microsoft.Graph.Users, Microsoft.Graph.Identity.DirectoryManagement
Connect-MgGraph -Scope User.read.all, DeviceManagementConfiguration.Read.All

$CompanyName = (Get-MgOrganization | Select VerifiedDomains).verifieddomains | Where-Object {$_.IsDefault -eq "True"}
$Users = Get-MgUser -all
$Report = [System.Collections.Generic.List[Object]]::new()
Write-host "Found $($users.count) users for $($CompanyName.Name)" -ForegroundColor Cyan
ForEach ($user in $Users) {
    Write-Host "Retrieving license info for $($User.DisplayName)" -ForegroundColor yellow
    If (Get-MgUserLicenseDetail -USerId $User.id) {
    $licenses = $null
    $licenses = (Get-MgUserLicenseDetail -UserId $User.id).SkuPartNumber -join ", "
    Write-Host "Licenses found for $($User.DisplayName): $licenses" -ForegroundColor cyan
    $obj = [pscustomobject][ordered]@{
            DisplayName       = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            Licenses          = $licenses
        }
    $report.Add($obj)
    } else {
    Write-Host "No licenses found for $($User.DisplayName)" -ForegroundColor Red
    }
}
$report | Export-CSV "C:\Data\licensedusers.csv" -NoTypeInformation