$directoryPath = "C:\Users"
$excludedFolders = @("Public", "Default", "Administrator", "Root", "root")
$dateToCheck = (Get-Date).AddDays(-30)
$directories = Get-ChildItem -Path $directoryPath -Directory | Where-Object { $_.Name -notin $excludedFolders -and $_.LastWriteTime -lt $dateToCheck }

foreach ($directory in $directories) {
    $userName = $directory.Name
    try {
        $runningProcesses = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.GetOwner().User -eq $userName }
    }
    catch {
        Write-Output "Error: $_"
    }
    if ($runningProcesses.Count -gt 0) {
        Write-Output "Terminating processes for user $userName"
        $runningProcesses | ForEach-Object {
            Stop-Process -Id $_.ProcessId -Force
        }
    }
    Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $userName } | Remove-CimInstance
}