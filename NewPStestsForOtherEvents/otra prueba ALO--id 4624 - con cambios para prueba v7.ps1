$NewArrayList = @() ; $FilteredArray = @() ; $z = 0 ; $FilteredArray += "-"
$FilteredArray[0] = "-"  # Esto es para inicializar el primer elemento del arreglo que se creó VACIO.
$result = Get-EventLog -LogName Security -InstanceId 4624
$ArrayMaximumSize = $result.count ; write-host "Conteo de número de eventos a revisar en LOG de SEGURIDAD " $ArrayMaximumSize
pause
For ($x = 0; $x -lt $ArrayMaximumSize; $x = $x + 1)
   {
    $element = $result[$x]
    $NewArrayList += "-"  # iniciliza nuevo elemento del ARREGLO con INDICE ADICIONAL para ser sustituido por @PSCUSTOMOBJECT
    $NewArrayList[$x] = [PSCustomObject]@{
     Time = $element.TimeGenerated
     Machine = $element.ReplacementStrings[6]
     User = $element.ReplacementStrings[5]
     Access = $element.ReplacementStrings[10]
     SourceAddr = $element.ReplacementStrings[18]
     field1 = $element.ReplacementStrings[1]
     field2 = $element.ReplacementStrings[2]
     field3 = $element.ReplacementStrings[3]
     field4 = $element.ReplacementStrings[4]
     field5 = $element.ReplacementStrings[5]
     field6 = $element.ReplacementStrings[6]
     field7 = $element.ReplacementStrings[7]
     field8 = $element.ReplacementStrings[8]
     field9 = $element.ReplacementStrings[9]
     field10 = $element.ReplacementStrings[10]
     field11 = $element.ReplacementStrings[11]
     field12 = $element.ReplacementStrings[12]
     field13 = $element.ReplacementStrings[13]
     field14 = $element.ReplacementStrings[14]
     field15 = $element.ReplacementStrings[15]
     field16 = $element.ReplacementStrings[16]
     field17 = $element.ReplacementStrings[17]
     field18 = $element.ReplacementStrings[18]
     field19 = $element.ReplacementStrings[19]
     field20 = $element.ReplacementStrings[20]
     field21 = $element.ReplacementStrings[21]
     field22 = $element.ReplacementStrings[22]
     field23 = $element.ReplacementStrings[23]
     field24 = $element.ReplacementStrings[24]
     field25 = $element.ReplacementStrings[25]
     }
     $TestAddr = $NewArrayList[$x].SourceAddr
     pause
     write-host $TestAddr

     if ($TestAddr -eq ("::1"))   {  }
     elseif ($TestAddr -eq ("-")) {  }
     else
      {
     write-host "EL IF de direcciones a descartar resulto negativo "
     $FilteredArray += "-" # agregando elemento en el ARREGLO FILTRADO SIN INCLUIR DIRECCIONES IP NO INTERESANTES como ("-")) y ("::1"))
     # $eventfiltered = $result[$x]   Comando original que se cambio por la siguiente linea
     $eventfiltered = $NewArrayList[$x]
     $FilteredArray[$z] = [PSCustomObject]@{
                Time = $eventfiltered.TimeGenerated
                Machine = $eventfiltered.ReplacementStrings[6]
                User = $eventfiltered.ReplacementStrings[5]
                Access = $eventfiltered.ReplacementStrings[10]
                SourceAddr = $eventfiltered.ReplacementStrings[18]
                field1 = $eventfiltered.ReplacementStrings[1]
                field2 = $eventfiltered.ReplacementStrings[2]
                field3 = $eventfiltered.ReplacementStrings[3]
                field4 = $eventfiltered.ReplacementStrings[4]
                field5 = $eventfiltered.ReplacementStrings[5]
                field6 = $eventfiltered.ReplacementStrings[6]
                field7 = $eventfiltered.ReplacementStrings[7]
                field8 = $eventfiltered.ReplacementStrings[8]
                field9 = $eventfiltered.ReplacementStrings[9]
                field10 = $eventfiltered.ReplacementStrings[10]
                field11 = $eventfiltered.ReplacementStrings[11]
                field12 = $eventfiltered.ReplacementStrings[12]
                field13 = $eventfiltered.ReplacementStrings[13]
                field14 = $eventfiltered.ReplacementStrings[14]
                field15 = $eventfiltered.ReplacementStrings[15]
                field16 = $eventfiltered.ReplacementStrings[16]
                field17 = $eventfiltered.ReplacementStrings[17]
                field18 = $eventfiltered.ReplacementStrings[18]
                field19 = $eventfiltered.ReplacementStrings[19]
                field20 = $eventfiltered.ReplacementStrings[20]
                field21 = $eventfiltered.ReplacementStrings[21]
                field22 = $eventfiltered.ReplacementStrings[22]
                field23 = $eventfiltered.ReplacementStrings[23]
                field24 = $eventfiltered.ReplacementStrings[24]
                field25 = $eventfiltered.ReplacementStrings[25]
                }


      $eventfiltered2 = $FilteredArray[$z]
      $eventfiltered2.SourceAddr

       $z = $z + 1  ; write-host "Z es igual a " $z ; write-host " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ " }
     }
   
   
   



# $result | get-member
pause
$x = 0 
if ($result[$x].SourceAddr -ne "::1") 
  {
      $result[$x].SourceAddr
      $X = $X + 1
 else
  {
      $X = $X + 1
  }
 
   } 
$result[0]
# $result2=$result | Select-Object Time, Machine, User, Access, SourceAddr, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field12, field13, field14, field15, field16,  field17, field18,  field19,  field20,  field21,  field22,  field23,  field24,  field25 
# $result2