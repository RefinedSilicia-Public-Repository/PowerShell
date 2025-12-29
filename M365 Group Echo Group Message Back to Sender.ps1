Connect-ExchangeOnline -UserPrincipalName bakesj@kyocera-sgstool.com
$Domain = "mail.kyocera-sgstool.com"
#Get all users in Exchange Online
$Users = Get-Mailbox -ResultSize Unlimited
Write-Host "Processing $($Users.Count) users..." -ForegroundColor Yellow
foreach ($User in $Users) {
Get-Mailbox -Identity $User | Set-MailboxMessageConfiguration -EchoGroupMessageBackToSubscribedSender $true
}
Write-Host "Done" -ForegroundColor Green