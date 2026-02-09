
$result = Get-EventLog -LogName Security -InstanceId 4624 |for ($x = 0; $x -lt 5; $x = $x + 1){
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
                       }
     write-host " Número de eventos procesados = $x "
     write-host  "Time = " $result[$x].Time
     write-host  "Machine = " $result[$x].Machine
     write-host  "User = " $result[$x].User
     write-host  "Access = " $result[$x].Access
     write-host  "SourceAddr = " $result[$x].SourceAddr
     write-host  " "
     write-host  " result array iterative object = " $result[$x]
     write-host " ****************************************************************************************************************************************** "
         }
   

   

$SourceIpAddresses=$result | Select-Object SourceAddr
# $SourceIpAddresses|get-member
$SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
$SourceIPgroup|Get-Member
$SourceIPgroup|select-object count,name,group,values|ft
$SourceIPgroup|select-object count,name,Values

 
