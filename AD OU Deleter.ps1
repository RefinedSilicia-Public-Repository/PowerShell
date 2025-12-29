#Get-ADOrganizationalUnit -identity "OU=SCCM-RMM,OU=All,DC=corp,DC=sgstool,DC=com" | Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru | Remove-ADOrganizationalUnit -Confirm:$false
Get-ADOrganizationalUnit -Properties CanonicalName -Filter * | Select-Object CanonicalName, DistinguishedName | Sort-Object CanonicalName
