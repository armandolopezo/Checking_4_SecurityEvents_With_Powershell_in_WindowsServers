$result = Get-EventLog -LogName Security -InstanceId 4624

for ($x = 0; $x -lt 100; $x = $x + 1) {
    $event = $result[$x]
    $TestAddr = $event.ReplacementStrings[18]
 
    $z = $x + 1

   # write-host "TestAddr=" $TestAddr "linea de impresion para llevar control de cada registro procesado. Registro Número: " $z

    

      #      if (1 -ne 9) {
      #          write-host "Boolean Test - esto es sólo un control para imprimir cada registro procesado " 
      #          write-host " *********************************************************************************** " 
                
            if ($TestAddr -eq ("::1")) { }
            elseif ($TestAddr -eq ("-")) { }
            else             {
                # write-host "EL IF de direcciones a descartar resulto negativo "
                [PSCustomObject]@{
                Time = $event.TimeGenerated
                Machine = $event.ReplacementStrings[6]
                User = $event.ReplacementStrings[5]
                Access = $event.ReplacementStrings[10]
                SourceAddr = $event.ReplacementStrings[18]
                                }
                $y=$x+1
                # write-host " ************************************************************************************************************************* "
                # write-host " Número de eventos PROCESADOS = $y "
                # write-host  "Time = " $event.TimeGenerated
                # write-host  "Machine = " $event.ReplacementStrings[6]
                # write-host  "User = " $event.ReplacementStrings[5]
                # write-host  "Access = " $event.ReplacementStrings[10]
                # write-host  "SourceAddr = " $event.ReplacementStrings[18]
                # write-host  " "
                # write-host  " result array iterative object = " $event
                                }
                             }
            
    
$SourceIpAddresses=$event | Select-Object SourceAddr
# $SourceIpAddresses|get-member
$SourceIPgroup = $SourceIpAddresses| group-object -Property SourceAddr
write-host $SourceIPgroup

$SourceIPgroup.group
## $SourceIPgroup|Get-Member
$SourceIPgroup|select-object count,name,group,values|ft
$SourceIPgroup|select-object count,name,Values