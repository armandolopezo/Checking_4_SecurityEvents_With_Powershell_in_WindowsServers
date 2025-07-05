# este script no me funciono
$z = 0
$result = Get-EventLog -LogName Security -InstanceId 4624 
$FilteredArray = $result
   ForEach ($element in $result) 
   {
                [PSCustomObject]@{
                Time = $element.TimeGenerated
                Machine = $element.ReplacementStrings[6]
                User = $element.ReplacementStrings[5]
                Access = $element.ReplacementStrings[10]
                SourceAddr = $element.ReplacementStrings[18]
                      }
     $TestAddr = $element.SourceAddr
      write-host " **** TestAddress es  "   $TestAddr

      write-host " *********************************************************************************************************** "   
          
      if ($TestAddr -eq ("::1"))         { write-host "TestAddress con IF 1 ip dir = ::1 " }
      elseif ($TestAddr -eq ("-"))       { write-host "TestAddress con IF 1 ip dir = - "   } 
      else                               {
                write-host "EL IF de direcciones a descartar resulto negativo "
                $FilteredArray[$z] = [PSCustomObject]@{
                Time = $element.TimeGenerated
                Machine = $element.ReplacementStrings[6]
                User = $element.ReplacementStrings[5]
                Access = $element.ReplacementStrings[10]
                SourceAddr = $element.ReplacementStrings[18]
                $z = $z + 1                           }
           
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

$SortedIPordered = $IPgrouped |Sort-Object -Property Count
$sourceIPcounted = $SourceIPordered |Sort-Object -Property Count -Descending
$sourceIPcounted
# write-host " ***************************************************************************************************** " 
# $SortedIP_Name_ordered = $IPgrouped |Sort-Object -Property Name
# $SortedIP_Name_ordered

 