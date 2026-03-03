$a=(Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624} -MaxEvents 1).Message.split(':') -split("`t") | ? { $_ -match '\d+\.\d+\.\d+.\d+'} | % {$_ -replace ("`n","")}
$a 


