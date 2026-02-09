$result = Get-EventLog -LogName Security -InstanceId 4625 |
   ForEach-Object {
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
     }
   }
   
# $result | Select-Object Time, Machine, User, Access, SourceAddr |  Export-Csv -NoTypeInformation -Path c:# \soporte\powershell\Access_Log.csv
# $result | Select-Object Time, Machine, User, Access, SourceAddr


$SourceIpAddresses=$result | Select-Object SourceAddr
# $SourceIpAddresses|get-member

# start-sleep -seconds 15

# write-host " ############################################################################################ "
# $SourceIpAddresses

# write-host " ******************************************************************************************** "


$SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
$SourceIPgroup|Get-Member
$SourceIPgroup|select-object count,name,group,values|ft
$SourceIPgroup|select-object count,name,Values

 
