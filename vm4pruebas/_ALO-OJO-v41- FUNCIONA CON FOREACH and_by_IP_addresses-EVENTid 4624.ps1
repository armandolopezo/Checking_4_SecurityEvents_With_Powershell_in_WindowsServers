﻿$result = Get-EventLog -LogName Security -InstanceId 4624 |
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
# $SourceIpAddresses
$SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
# $SourceIPgroup
# $SourceIPgroup.group
# $SourceIPgroup|Get-Member
# $SourceIPgroup|select-object count,name,group,values
# $SourceIPgroup

$IPgrouped = $SourceIPgroup|select-object count,name
# $IPgrouped
 
# IPgrouped |Get-Member
# $IPgrouped |Get-Member -MemberType *property*
# $IPgrouped |Get-Member -MemberType method

# SortedIPordered = $IPgrouped |Sort-Object -Property Count
# sourceIPcounted = $SourceIPordered |Sort-Object -Property Count -Descending
# sourceIPcounted
# write-host " ***************************************************************************************************** " 
$SortedIP_Name_ordered = $IPgrouped |Sort-Object -Property Name
$SortedIP_Name_ordered

 