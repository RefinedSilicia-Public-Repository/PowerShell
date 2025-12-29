# CrowdStrikeFix.ps1
# This script deletes the problematic CrowdStrike driver file causing BSODs and reverts Safe Mode

$filePath = "C:\Windows\System32\drivers\C-00000291*.sys"
$files = Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue

foreach ($file in $files) {
    try {
        Remove-Item -Path $file.FullName -Force
        Write-Output "Deleted: $($file.FullName)"
    } catch {
        Write-Output "Failed to delete: $($file.FullName)"
    }
}

# Revert Safe Mode Boot after Fix
bcdedit /deletevalue {current} safeboot