$result = Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} -MaxEvents 100 | ForEach-Object {
    # convert the event to XML and grab the Event node
    $eventXml = ([xml]$_.ToXml()).Event
    # output the values from the XML representation
    [PsCustomObject]@{
        UserName  = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
        IpAddress = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' }).'#text'
        EventDate = [DateTime]$eventXml.System.TimeCreated.SystemTime
    }
}
$result.ipaddress
