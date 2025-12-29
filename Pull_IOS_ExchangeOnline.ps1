Connect-ExchangeOnline
Get-MobileDevice -ResultSize unlimited | Select DeviceModel,Identity,UserDisplayName | Export-Csv C:\temp\sample.csv -NoTypeInformation