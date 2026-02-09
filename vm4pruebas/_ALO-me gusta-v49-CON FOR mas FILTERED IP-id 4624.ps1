# $NewArrayList = @(1..1000000) ; $FilteredArray = @(1..1000000)
$z = 0
$NewArrayList = @() ; $FilteredArray = @() ; $result = Get-EventLog -LogName Security -InstanceId 4624 
$ArrayMaximumSize = $result.count ; write-host "Conteo de número de eventos a revisar en LOG de SEGURIDAD " $ArrayMaximumSize
write-host " *********************************************************************************************************** "   
For ($x = 0; $x -lt $ArrayMaximumSize; $x = $x + 1)
   {$element = $result[$x]
    $NewArrayList += "-"
    $NewArrayList[$x] = [PSCustomObject]@{
    Time = $element.TimeGenerated
    Machine = $element.ReplacementStrings[6]
    User = $element.ReplacementStrings[5]
    Access = $element.ReplacementStrings[10]
    SourceAddr = $element.ReplacementStrings[18] }
    # las siguientes 3 lineas con comando WRITE-HOST permiten vericar el acceso al arreglo NEWARRAYLIST teniendo como indice de la variable X,
    # la impresion del objeto creado con PSCUSTOBJECT y la asignacion la variable TESTADDR con la propiedad SourceAddr
    # write-host $NewArrayList[$x] ; write-host " **** TestAddress es  " $NewArrayList[$x].SourceAddr ; $TestAddr = $NewArrayList[$x].SourceAddr
    # write-host " **** TestAddress es (segunda verificacion) " $TestAddr
    # write-host " *********************************************************************************************************** "   
    # El siguiente comando lo puedo activar para una verificacion lenta de que funcionan $NewArrayList[$x] y $TestAddr
    # start-sleep 5
    $TestAddr = $NewArrayList[$x].SourceAddr  
    if ($TestAddr -eq ("::1"))   {  }
    elseif ($TestAddr -eq ("-")) {  }
    else {
    write-host "EL IF de direcciones a descartar resulto negativo "
    $FilteredArray += "-"
    $eventfiltered = $result[$x]
    # $eventfiltered.ReplacementStrings
    $eventfiltered.ReplacementStrings[18]
    $FilteredArray[$z] = [PSCustomObject]@{
                Time = $eventfilted.TimeGenerated
                Machine = $eventfiltered.replacementStrings[6]
                User = $eventfiltered.ReplacementStrings[5]
                Access = $eventfiltered.ReplacementStrings[10]
                SourceAddr = $eventfiltered.ReplacementStrings[18] }
      $z = $z + 1  ; write-host "Z es igual a " $z ; write-host " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ " 
      write-host $FilteredArray[$z] ; write-host " ---- La prueba 2 de dirección IP " $FilteredArray[$z].SourceAddr ; $TestAddrV2 = $FilteredArray[$z].SourceAddr
      write-host "  ---- La prueba 2 de dirección IP es la (segunda verificacion) " $TestAddrV2
      write-host " --------------------------------------------------------------------------------------------------------------- "  }
                                    }

  #     El siguiente comando lo puedo activar para una verificacion lenta del arreglo $FilteredArray[$z]  y $TestAddr
  #              #
                # start-sleep 5    
                #
                         
  #              $FilteredIPaddressObject = $FilteredArray[$z]
  #              $FilteredIPaddress = $FilteredIPaddressObject | Select-Object SourceAddr 
                                           
      #          write-host " Impresion de Source IP Address de FilteredArray con indice Z "$FilteredIPaddress
      #          write-host " El número de registros de FILTEREDARRAY es " $z
                                       
    
# $result | Select-Object Time, Machine, User, Access, SourceAddr |  Export-Csv -NoTypeInformation -Path c:# \soporte\powershell\Access_Log.csv
# $result | Select-Object Time, Machine, User, Access, SourceAddr
# $SourceIpAddresses = $FilteredArray | Select-Object SourceAddr
# $SourceIpAddresses
# $SourceIPgroup = $SourceIpAddresses| group-object -Property SourceAddr 
# $SourceIPgroup
# $SourceIPgroup.group
# $SourceIPgroup|Get-Member
# $SourceIPgroup|select-object count,name,group,values
# $SourceIPgroup

# $IPgrouped = $SourceIPgroup|select-object count,name
# $IPgrouped
 
# IPgrouped |Get-Member
# $IPgrouped |Get-Member -MemberType *property*
# $IPgrouped |Get-Member -MemberType method

# $SortedIPordered = $IPgrouped |Sort-Object -Property Count
# $sourceIPcounted = $SourceIPordered |Sort-Object -Property Count -Descending
# $sourceIPcounted
# write-host " ***************************************************************************************************** " 
# $SortedIP_Name_ordered = $IPgrouped |Sort-Object -Property Name
# $SortedIP_Name_ordered
