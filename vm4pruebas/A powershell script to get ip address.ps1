# https://community.spiceworks.com/t/a-powershell-script-to-get-the-ip-address-that-users-used-to-log-into-a-remoteap/954385/3
#
# A powershell script to get ip address
#
#
# $eventLog = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} -MaxEvents 100 |
#            Where-Object {$_.Properties[5].Value -eq $env:USERNAME} |
#            Select-Object -ExpandProperty Properties
$eventLog = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=21} -MaxEvents  100
            Where-Object {$_.Properties[5].Value -eq $env:USERNAME} |
            Select-Object -ExpandProperty Properties
$ipAddresses = $eventLog | Where-Object {$_.Name -eq 'IpAddress'} | Select-Object -ExpandProperty Value
# Export IP addresses to CSV file
$csvPath = "C:\soporte\output.csv"
$csvData = $ipAddresses | Select-Object @{Name='IP Address'; Expression={$_}}
$csvData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "IP addresses exported to $csvPath."


