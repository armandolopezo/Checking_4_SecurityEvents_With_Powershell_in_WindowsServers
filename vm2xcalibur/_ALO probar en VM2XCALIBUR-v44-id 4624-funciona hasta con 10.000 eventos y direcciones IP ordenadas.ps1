$result = Get-EventLog -LogName Security -InstanceId 4624
$results2 = @()
$results3 = @()     
$results2 = 1..10000 | ForEach-Object { "" } # the following line is for a counter for valid IP address for a TRUE valid in the IF $TestAddr in the FOR  loop below.$y = 0# in the following LOOP I will process 10.000 events that is the limit for the $x variable
    for ($x = 0; $x -lt 10000; $x = $x + 1) {
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
# The rable in the following line works without sorting IP addresses
# $SourceIPgroup|select-object count,name

$SourceIPgroup2=$SourceIPgroup|select-object count,name
$SortedIPaddresses=$SourceIPgroup2|Sort-Object -Property count -Descending
$SortedIPaddresses

# follwing line prints $y variable (counter of valid ip addresses)
# write-host "variable y es: $y"

$results3 = 1..$y | ForEach-Object { "1" } 

# following line prints a sequence of "1".
# write-host "Results3 array print:  $results3"

for ($y2 = 0; $y2 -lt $y; $y2 = $y2 + 1)  {
    $results3[$y2] =  $results2[$y2]
    write-host  $results3[$y2]  
    write-host "Y2 counter $y2"
    }