# get-winevent -LogName security -maxevents 30|Get-Member
$eventlog=get-winevent -LogName security -maxevents 30|Select-Object logname,id
$eventlog




