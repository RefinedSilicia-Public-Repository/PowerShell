Connect-ExchangeOnline;
Get-DynamicDistributionGroupMember -Identity TestGen1 | Export-Csv -Path "C:\temp\Processes.csv"
#Get-DynamicDistributionGroup -ResultSize unlimited | Format-List Name,HiddenFromAddressListsEnabled,MaxReceiveSize,ModerationEnabled,ModeratedBy