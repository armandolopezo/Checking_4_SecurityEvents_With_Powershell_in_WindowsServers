$result = Get-EventLog -LogName Security -InstanceId 4624
$results2 = @()  
$results2 = 1..1000 | ForEach-Object { "" } # the following line is for a counter for valid IP address for a TRUE valid in the IF $TestAddr in the FOR  loop below.$y = 0# in the following LOOP I will process 1.000 events that is the limit for the $x variable
    for ($x = 0; $x -lt 10; $x = $x + 1) {
        $event = $result[$x] 
        $TestAddr = $event.ReplacementStrings[18]
        # The following LINE prints de TEST ADDRESS in console
        # write-host "Test Address:  $TestAddr"
        #   if ($TestAddr -ne ("::1" -or "-" -or "127.0.0.1")) {   <------ This IF failed
               if ($TestAddr -ne "::1") {
                 if ($TestAddr -ne "-")   {
                    if ($TestAddr -ne "127.0.0.1") {
                       # The following line can show de IP Address to verify that is not "::1" -or "-" -or "127.0.0.1" 
                       # write-host "Test Address $TestAddr"
                       # The following line below verifies that $TestAddr is a STRING
                       # $TestAddr.GetType()
                       $results2[$y]=[PSCustomObject]@{
                       Time = $event.TimeGenerated
                       Machine = $event.ReplacementStrings[6]
                       User = $event.ReplacementStrings[5]
                       Access = $event.ReplacementStrings[10]
                       SourceAddr = $event.ReplacementStrings[18]}    
                       $y=$y+1     }
                          }
                      }
                   } 
               # THe following instructions "counts"number of processed events
               # write-host " Número de eventos procesados = $y "
    # write-host  "Time = " $event.TimeGenerated
    # write-host  "Machine = " $event.ReplacementStrings[6]
    # write-host  "User = " $event.ReplacementStrings[5]
    # write-host  "Access = " $event.ReplacementStrings[10]
    # write-host  "SourceAddr = " $event.ReplacementStrings[18]
    # write-host  " "
    # write-host  " result array iterative object = " $event
    # write-host " ****************************************************************************************************************************************** "

   
$SourceIpAddresses=$results2 | Select-Object SourceAddr
# The following line can show the processed IP ADDRESS IN THE EVENT
# $SourceIpAddresses
# $SourceIpAddresses|get-member
$SourceIPgroup = $SourceIpAddresses| group-object -Property SourceAddr
#$SourceIPgroup

# $SourceIPgroup.group
# $SourceIPgroup|Get-Member
# $SourceIPgroup|select-object count,name,group,values|ft
$SourceIPgroup|select-object count,name|ft

 
