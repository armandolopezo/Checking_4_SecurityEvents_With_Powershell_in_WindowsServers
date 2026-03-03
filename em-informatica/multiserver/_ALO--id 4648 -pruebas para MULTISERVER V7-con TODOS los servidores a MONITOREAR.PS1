<#
.SYNOPSIS
    Monitoreo de eventos 4648 servidor por servidor.
.DESCRIPTION
    Extrae y agrupa las IPs de origen individualmente para cada servidor en la lista.
#>

$Servidores = @("vm4pruebas", "serverhpg6", "ciscoserver", "vm2xcalibur","vm1dc", "vm2dc")

# Bloque que extrae los datos puros (se ejecuta en el remoto)
$MonitorBlock = {
    try {
        $result = Get-EventLog -LogName Security -InstanceId 4648 -ErrorAction Stop
        foreach ($element in $result) {
            $TestAddr = $element.ReplacementStrings[12]
            if ($TestAddr -ne "::1" -and $TestAddr -ne "-") {
                [PSCustomObject]@{
                    SourceAddr = $TestAddr
                    Time       = $element.TimeGenerated
                }
            }
        }
    }
    catch {
        return $null
    }
}

# --- EJECUCIÓN ---

foreach ($srv in $Servidores) {
    Write-Host "`n" + ("=" * 60) -ForegroundColor Gray
    Write-Host " ANALIZANDO SERVIDOR: $($srv.ToUpper()) " -BackgroundColor Blue -ForegroundColor White
    Write-Host ("=" * 60) -ForegroundColor Gray

    try {
        # Ejecutamos el comando solo para ESTE servidor en esta vuelta del bucle
        $DatosServidor = Invoke-Command -ComputerName $srv -ScriptBlock $MonitorBlock -ErrorAction Stop

        if ($null -ne $DatosServidor) {
            # Aquí aplicamos tu lógica de agrupación solo a los datos de este servidor
            $SortedIPs = $DatosServidor | Group-Object -Property SourceAddr | 
                Select-Object Count, @{Name="IP_Address"; Expression={$_.Name}} | 
                Sort-Object -Property Count -Descending

            $SortedIPs | Format-Table -AutoSize
            Write-Host "[OK] Total de IPs únicas encontradas: $($SortedIPs.Count)" -ForegroundColor Green
        }
        else {
            Write-Warning "No se encontraron eventos 4648 en $srv (o la IP era local/vacía)."
        }
    }
    catch {
        Write-Host "[ERROR] No se pudo conectar a $srv o el log no es accesible." -ForegroundColor Red
        Write-Host "Detalle: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

Write-Host "`n--- Proceso finalizado en todos los servidores ---" -ForegroundColor Cyan