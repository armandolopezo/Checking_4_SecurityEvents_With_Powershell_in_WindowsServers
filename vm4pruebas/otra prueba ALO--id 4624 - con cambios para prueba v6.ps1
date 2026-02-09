$result = Get-EventLog -LogName Security -InstanceId 4624 |
   ForEach-Object {
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
     field1 = $_.ReplacementStrings[1]
     field2 = $_.ReplacementStrings[2]
     field3 = $_.ReplacementStrings[3]
     field4 = $_.ReplacementStrings[4]
     field5 = $_.ReplacementStrings[5]
     field6 = $_.ReplacementStrings[6]
     field7 = $_.ReplacementStrings[7]
     field8 = $_.ReplacementStrings[8]
     field9 = $_.ReplacementStrings[9]
     field10 = $_.ReplacementStrings[10]
     field11 = $_.ReplacementStrings[11]
     field12 = $_.ReplacementStrings[12]
     field13 = $_.ReplacementStrings[13]
     field14 = $_.ReplacementStrings[14]
     field15 = $_.ReplacementStrings[15]
     field16 = $_.ReplacementStrings[16]
     field17 = $_.ReplacementStrings[17]
     field18 = $_.ReplacementStrings[18]
     field19 = $_.ReplacementStrings[19]
     field20 = $_.ReplacementStrings[20]
     field21 = $_.ReplacementStrings[21]
     field22 = $_.ReplacementStrings[22]
     field23 = $_.ReplacementStrings[23]
     field24 = $_.ReplacementStrings[24]
     field25 = $_.ReplacementStrings[25]
     }
   }
# $result | get-member
pause
$result.SourceAddr
$result[0]
# $result2=$result | Select-Object Time, Machine, User, Access, SourceAddr, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field12, field13, field14, field15, field16,  field17, field18,  field19,  field20,  field21,  field22,  field23,  field24,  field25 
# $result2