$result1 = Get-EventLog -LogName Security -InstanceId 4624 
# $result1|Get-Member
$result2=$result1
$result3=$result2|select-object  timegenerated, replacementStrings
# $result3=$result2|select-object -first 5 timegenerated, replacementStrings
# $result3
# $result4=$result2|select-object -first 5 timegenerated, replacementStrings | format-table
 # $result4
# $result5=$result2|select-object -first 5 timegenerated, replacementStrings | format-list
 # $result5
$result6=$result2|select-object  replacementStrings
 # $result6=$result2|select-object -first 5 replacementStrings
# $result6
# $result7=$result2|select-object -first 5 replacementStrings | format-table
 # $result7
$result8=$result2|select-object replacementStrings | format-list
 $result8 = $result6
 # $result8
 # $result8[0]|Get-Member
 #  $result8[0],replacementStrings
 # $result8[1].replacementStrings
 # $result8[1].replacementStrings[0]
 # $result8[1].replacementStrings[1]
 # $result8[1].replacementStrings[2]
 # $result8[1].replacementStrings[3]


#  $result8[1].replacementStrings[6]
# $result8[1].replacementStrings[5]
# $result8[1].replacementStrings[10]
# $result8[1].replacementStrings[18]

$x = 1
while ($x -lt 10000)
{
    $x
    
  # $result8[$x].replacementStrings[6]
  # $result8[$x].replacementStrings[5]
  # $result8[$x].replacementStrings[10]
  $result8[$x].replacementStrings[18] 

    $x = $x + 1
}



 # $result8[2]
 # $result8[3]
 # $result8


 # $field1=$result8.replacementStrings
  # $field1

# $result = Get-EventLog -LogName Security -InstanceId 4624 |l5
 #  ForEach-Object {
  #   [PSCustomObject]@{
   #  Time = $_.TimeGenerated
    # Machine = $_.ReplacementStrings[6]
     # User = $_.ReplacementStrings[5]
     # Access = $_.ReplacementStrings[10]
     # SourceAddr = $_.ReplacementStrings[18]
     # }
   # }
   
# $result | Select-Object Time, Machine, User, Access, SourceAddr |  Export-Csv -NoTypeInformation -Path c:# \soporte\powershell\Access_Log.csv
# $result | Select-Object Time, Machine, User, Access, SourceAddr
# $SourceIpAddresses=$result | Select-Object SourceAddr
# $SourceIpAddresses
# write-host "############################################################################################"
# $SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
# $SourceIPgroup
# $SourceIPgroup.group
# $SourceIPgroup|Get-Member
# $SourceIPgroup|select-object count,name,group,values
# $SourceIPgroup|select-object count,name

 
