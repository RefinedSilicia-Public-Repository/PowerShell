$computer = ‘C4RESEARCH’

Get-ChildItem “\\$computer\c$\Users” | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 1