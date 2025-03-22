# $result = Get-EventLog -LogName Security -InstanceId 4624
# write-host " imprimir resultado de metodo COUNT para variable RESULT que tiene los eventos "
# $result.count
# start-sleep -seconds 5
# $result[0] | fl * 
# write-host " ############################################################################################ "
# start-sleep -seconds 15

$x = 0
$result = Get-EventLog -LogName Security -InstanceId 4624 |
   ForEach-Object {
          while ($x -lt 10000)
        {
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
                       }
     $x = $x + 1
     write-host " Número de eventos procesados = $x "
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

 
