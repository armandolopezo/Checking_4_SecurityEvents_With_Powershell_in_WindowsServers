
$result = Get-EventLog -LogName Security -InstanceId 4624

for ($x = 0; $x -lt 5; $x = $x + 1) {
    $event = $result[$x]
    $TestAddr = $event.ReplacementStrings[18]
 
    write-host "TestAddr=" $TestAddr
            if (1 -eq 9) {
                write-host "Boolean = " 
                }
            if ($TestAddr -ne "::1") {
                write-host "EL IF de direcciones resulto negativo "
                [PSCustomObject]@{
                Time = $eventn.TimeGeneratedcls
                Machine = $event.ReplacementStrings[6]
                User = $event.ReplacementStrings[5]
                Access = $event.ReplacementStrings[10]
                SourceAddr = $event.ReplacementStrings[18]
                                }
                $y=$x+1
                write-host " Número de eventos procesados = $y "
                write-host  "Time = " $event.TimeGenerated
                write-host  "Machine = " $event.ReplacementStrings[6]
                write-host  "User = " $event.ReplacementStrings[5]
                write-host  "Access = " $event.ReplacementStrings[10]
                write-host  "SourceAddr = " $event.ReplacementStrings[18]
                write-host  " "
                #  write-host  " result array iterative object = " $event
                write-host " ************************************************************************************************************************* "
                             }
             }
    
    
## $SourceIpAddresses=$result | Select-Object SourceAddr
# $SourceIpAddresses|get-member
## $SourceIPgroup= $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
## $SourceIPgroup|Get-Member
## $SourceIPgroup|select-object count,name,group,values|ft
## $SourceIPgroup|select-object count,name,Values

 
