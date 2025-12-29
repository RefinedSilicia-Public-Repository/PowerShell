#Variables
$sourceDirectory = "C:\Users\bakesj\OneDrive - Kyocera SGS Precision Tools\Excel\Domain_Data"
$currentFile = Get-ChildItem $sourceDirectory -Filter *.xlsx
$sourceHeader1 = "Computer Name"
$sourceHeader2 = "Remarks"
#$sourceFile = 'C:\Users\bakesj\OneDrive - Kyocera SGS Precision Tools\Excel\Domain_Data\SoMManagedComputers.xlsx'
$sheetName = "ManageEngine Endpoint Central C"

#for loop created around the idea that there are multipe excel files in a directory
foreach ($file in $ExcelFiles)
{
    $ImportFile = -JOIN($sourceDirectory,$file)
    $DestinationFile = -JOIN($SourceFileDirectory,$TestFile,"_",$CurrentDate,$ExcelExt)

    $sheetName = 'ExampleSheet' # => Define the WorkSheet Name here

    Write-Host $ImportFile
    Write-Host $DestinationFile

    $xlsx = Import-Excel -Path $ImportFile -HeaderName $headers -StartRow 2 |
    Select-Object * -ExcludeProperty Dupe* |
    Export-Excel -Path $DestinationFile -PassThru -WorksheetName $sheetName
    
    $ws = $xlsx.Workbook.Worksheets[$sheetName]
    Set-ExcelRange -HorizontalAlignment Center -Worksheet $ws -Range $ws.Dimension.Address
    Close-ExcelPackage $xlsx
}