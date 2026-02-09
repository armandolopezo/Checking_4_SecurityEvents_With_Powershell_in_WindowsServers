# $NewArrayList = @() ; $FilteredArray = @() ; $z = 0 ; $FilteredArray += "-"
$NewArrayList = @()  
$z = 0  
$FilteredArray = @(1..1000000)
# $FilteredArray[0] = "-"  # Esto es para inicializar el primer elemento del arreglo que se creó VACIO.
# $FilteredArray[0]
# write-host "Lo anterior es el valor de FilteredArray[0] "
# pause
write-host " Por favor espere unos segundos hasta QUE SE CUENTEN EL TOTAL DE EVENTOS A ANALIZAR "
$result = Get-EventLog -LogName Security -InstanceId 4625
$ArrayMaximumSize = $result.count ; write-host "Conteo de número de eventos a revisar en LOG de SEGURIDAD: " $ArrayMaximumSize
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
     SourceAddr = $element.ReplacementStrings[12]
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
     # write-host $TestAddr --> SI SE QUITA esta linea y la siguiente con instrucción PAUSE puede verificarse $TestAddr
     # pause


     if ($TestAddr -eq ("::1"))   {  }
     elseif ($TestAddr -eq ("-")) {  }
     else
      {
     # write-host "EL resultado de IF con resultado negativo (else) despues de descartar direcciones IP que no son de interes  "
     $FilteredArray += "-" # agregando elemento en el ARREGLO FILTRADO SIN INCLUIR DIRECCIONES IP NO INTERESANTES como ("-")) y ("::1"))
     $eventfiltered = $result[$x]   
     # $eventfiltered = $NewArrayList[$x] <-- HICE esto primero pero no funciona,trabaja con el ANTERIOR con el arreglo de objetos orginales en vez de los objetos del arreglo NEWARRAYLIST
     # write-host "la siguiente linea nuestra un valor de la VARIABLE EVENTFILTERED con el valor de un evento filtrado usando un valor indexando con VARIABLE X el arreglo ORIGINAL RESULT. "
     # $eventfiltered
     # pause
     write-host " *************************************************************************************************************************** "
     # write-host " Se muestra a continuación el valor de la variable Z : $z "
     # write-host "  "
     # write-host " Se muestra EN LA SIGUIENTE LINEA el valor del arreglo FilteredArray usando el indice de la variable Z antes de revisar los eventos "
     
     $FilteredArray[$z] = $eventfiltered
     # $FilteredArray[$z]

     # write-host "  "
     # write-host " *************************************************************************************************************************** "
    
     $FilteredArray[$z] = [PSCustomObject]@{
                Time = $eventfiltered.TimeGenerated
                Machine = $eventfiltered.ReplacementStrings[6]
                User = $eventfiltered.ReplacementStrings[5]
                Access = $eventfiltered.ReplacementStrings[10]
                SourceAddr = $eventfiltered.ReplacementStrings[12]
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
      write-host "Time: " $eventfiltered2.Time 
      write-host "Machine: " $eventfiltered2.Machine 
      write-host "User: " $eventfiltered2.User
      write-host "Access: " $eventfiltered2.Access
      write-host "SourceAddr: " $eventfiltered2.SourceAddr
      write-host "field1: " $eventfiltered2.field1
      write-host "field2: " $eventfiltered2.field2
      write-host "field3: " $eventfiltered2.field3
      write-host "field4: " $eventfiltered2.field4
      write-host "field5: " $eventfiltered2.field5
      write-host "field6: " $eventfiltered2.field6
      write-host "field7: " $eventfiltered2.field7
      write-host "field8: " $eventfiltered2.field8
      write-host "field9: " $eventfiltered2.field9
      write-host "field10: " $eventfiltered2.field10
      write-host "field11: " $eventfiltered2.field11
      write-host "field12: " $eventfiltered2.field12
      write-host "field13: " $eventfiltered2.field13
      write-host "field14: " $eventfiltered2.field14
      write-host "field15: " $eventfiltered2.field15
      write-host "field16: " $eventfiltered2.field16
      write-host "field17: " $eventfiltered2.field17
      write-host "field18: " $eventfiltered2.field18
      write-host "field19: " $eventfiltered2.field19
      write-host "field20: " $eventfiltered2.field20
      write-host "field21: " $eventfiltered2.field21
      write-host "field22: " $eventfiltered2.field22
      write-host "field23: " $eventfiltered2.field23
      write-host "field24: " $eventfiltered2.field24
      write-host "field25: " $eventfiltered2.field25
      
      write-host " "

      $z = $z + 1  ; write-host "Z es igual a " $z ; write-host " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ " 
       }
     }
   
   
   



# $result | get-member
# pause
# $x = 0 
# if ($result[$x].SourceAddr -ne "::1") 
#  {
#      $result[$x].SourceAddr
#      $X = $X + 1
# else
#  {
#      $X = $X + 1
#  }
# 
#   } 
# $result[0]
# $result2=$result | Select-Object Time, Machine, User, Access, SourceAddr, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field12, field13, field14, field15, field16,  field17, field18,  field19,  field20,  field21,  field22,  field23,  field24,  field25 
# $result2