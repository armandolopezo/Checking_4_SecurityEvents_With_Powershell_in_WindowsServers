$regex = [regex]::new("\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b")
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} -MaxEvents 100 | Foreach {$regex.Match($_.Message).Value}


