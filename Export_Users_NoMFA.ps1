# Import the required module
#Import-Module MSOnline

# Get your tenant credentials
#$credential = Get-Credential

# Connect to your tenant
#Connect-MsolService -Credential $credential

# Get all users
$users = Get-AzureADUser -All

# Select required properties and add new ones for Account Status, MFA Status, UPN
$userProperties = $users | Select-Object @{
    Name = "Account Status"
    Expression = {
        if ($_.BlockCredential) {
            "Disabled"
        } else {
            "Enabled"
        }
    }
}, @{
    Name = "MFA Status"
    Expression = {
        if ($_.StrongAuthenticationMethods.Count -eq 0) {
            "Disabled"
        } else {
            "Enabled"
        }
    }
}, DisplayName, FirstName, LastName, UserPrincipalName

# Sort users by DisplayName
$sortedUsers = $userProperties | Sort-Object DisplayName

# Export users to a CSV file
$sortedUsers | Export-Csv -Path "C:\temp\MfaDisabledUsers.csv" -NoTypeInformation