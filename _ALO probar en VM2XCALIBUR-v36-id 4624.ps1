﻿
$result = Get-EventLog -LogName Security -InstanceId 4624
$results2 = @() 
$results2 = 1..1000 | ForEach-Object { "" }# in the following LOOP I will process 1.000 events that is the limit for the $x variable
    for ($x = 0; $x -lt 1000; $x = $x + 1) {
        $event = $result[$x] 
        $TestAddr = $event.ReplacementStrings[18]
        write-host "Test Address:  $TestAddr"
            if ($TestAddr -ne ('::1' -or '-' -or '127.0.0.1')) {
                $results2[$x]=[PSCustomObject]@{
                Time = $event.TimeGenerated
                Machine = $event.ReplacementStrings[6]
                User = $event.ReplacementStrings[5]
                Access = $event.ReplacementStrings[10]
                SourceAddr = $event.ReplacementStrings[18]
                             }
                          }
               $y=$x+1
               # THe following instructions "counts"number of processed events
               write-host " Número de eventos procesados = $y "
    # write-host  "Time = " $event.TimeGenerated
    # write-host  "Machine = " $event.ReplacementStrings[6]
    # write-host  "User = " $event.ReplacementStrings[5]
    # write-host  "Access = " $event.ReplacementStrings[10]
    # write-host  "SourceAddr = " $event.ReplacementStrings[18]
    # write-host  " "
    # write-host  " result array iterative object = " $event
    # write-host " ****************************************************************************************************************************************** "
}
   
$SourceIpAddresses=$results2 | Select-Object SourceAddr
# The following line can show the processed IP ADDRESS IN THE EVENT
$SourceIpAddresses
# $SourceIpAddresses|get-member
$SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
$SourceIPgroup|Get-Member
$SourceIPgroup|select-object count,name,group,values|ft
$SourceIPgroup|select-object count,name,Values

 
