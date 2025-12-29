# This script requires the GroupPolicy PowerShell module, which is part of the RSAT tools
Import-Module GroupPolicy
# Get all GPOs in the current domain
$GPOs = Get-GPO -All
# Loop through each GPO and check for the specified permission
foreach ($GPO in $GPOs) {
    $GPOReport = Get-GPOReport -Guid $GPO.Id -ReportType Xml
    $GPOXml = [xml]$GPOReport
    # Check if 'Add workstations to domain' permission exists
    $userRightsAssignments = $GPOXml.GPO.Computer.ExtensionData.Extension.UserRightsAssignment
    $addWorkstationsToDomain = $userRightsAssignments.Name | Where-Object { $_ -eq 'SeMachineAccountPrivilege' }
    if ($addWorkstationsToDomain) {
        # Output the GPO name that contains the permission
        Write-Host "GPO with 'Add workstations to domain' permission found: " $GPO.DisplayName
    }
}
# Function to get the current Machine Account Quota
function Get-MachineAccountQuota {
    # Retrieves the distinguished name of the domain and gets the Machine Account Quota property
    $domainDN = (Get-ADDomain).distinguishedname
    $domainObject = Get-ADObject -Identity $domainDN -Properties ms-DS-MachineAccountQuota
    $currentQuota = $domainObject."ms-DS-MachineAccountQuota"
    Write-Output "Current Machine Account Quota: $currentQuota"
}
Get-MachineAccountQuota
# End of script