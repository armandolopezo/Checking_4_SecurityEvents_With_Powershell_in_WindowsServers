$result = Get-EventLog -LogName Security -InstanceId 4624 |
   ForEach-Object {
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
     }
   }
# The following command generates a file for checking Source IP Address in a saved file  
$result | Select-Object Time, Machine, User, Access, SourceAddr |  Export-Csv -NoTypeInformation -Path e:\soporte\powershell\Access_Log.csv
# The following command shows IP addresses in screen (console)
$result | Select-Object Time, Machine, User, Access, SourceAddr


$SourceIpAddresses=$result | Select-Object SourceAddr
# $SourceIpAddresses|get-member

# start-sleep -seconds 15

# write-host " ############################################################################################ "
# $SourceIpAddresses

# write-host " ******************************************************************************************** "


$SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
# the followind command shows PROPERTIES Y METHODS from the group in the variable $SourceIPgroup
$SourceIPgroup|Get-Member
# The following command shows the properties COUNT, NAME(ip address) and group of source addresses (colud be an array or collection with the same
# ip address repeated several times) in a table. 
$SourceIPgroup|select-object count,name,group|ft
# the following command shows the MOST IMPORTANT properties: COUNT and NAME (ip address) because "values" property is the same IP ADDRESS that 
# appears in property NAME but in square brackets {} 
$SourceIPgroup|select-object count,name,Values

 
