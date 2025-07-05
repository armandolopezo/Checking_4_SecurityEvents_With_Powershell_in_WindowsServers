$z = 0
$result = Get-EventLog -LogName Security -InstanceId 4624 
$FilteredArray = $result
$NewArrayList = $result
   For ($x = 0; $x -lt $result.count; $x = $x + 1)
   {            $element = $result[$x]
                $NewArrayList[$x] = [PSCustomObject]@{
                Time = $element.TimeGenerated
                Machine = $element.ReplacementStrings[6]
                User = $element.ReplacementStrings[5]
                Access = $element.ReplacementStrings[10]
                SourceAddr = $element.ReplacementStrings[18]
                      }
      #write-host $NewArrayList[$x] 
      # write-host " **** TestAddress es  " $NewArrayList[$x].SourceAddr
      $TestAddr = $NewArrayList[$x].SourceAddr
      # write-host " *********************************************************************************************************** "   
          
      if ($TestAddr -eq ("::1"))         {  }
      elseif ($TestAddr -eq ("-"))       {  } 
      else                               {
                # write-host "EL IF de direcciones a descartar resulto negativo "
                $FilteredArray[$z] = [PSCustomObject]@{
                Time = $element.TimeGenerated
                Machine = $element.ReplacementStrings[6]
                User = $element.ReplacementStrings[5]
                Access = $element.ReplacementStrings[10]
                SourceAddr = $element.ReplacementStrings[18]
                $z = $z + 1                           }
           
                write-host " Impresion de FilteredArray con indice Z " $FilteredArray[$z]
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

 