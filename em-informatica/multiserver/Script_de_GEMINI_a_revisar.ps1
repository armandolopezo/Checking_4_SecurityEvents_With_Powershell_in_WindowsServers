<#
.SYNOPSIS
    Monitoreo centralizado de intentos de inicio de sesión fallidos (Evento 4625).
.DESCRIPTION
    Este script se conecta a múltiples servidores en paralelo, extrae los campos de las 
    ReplacementStrings y agrupa las IPs de origen que intentan vulnerar el sistema.
#>

# 1. Configuración de servidores
$Servidores = @("vm4pruebas", "vm2xcalibur", "vm1dc", "vm2dc", "serverhpg6", "ciscoserver", "10.0.0.220","10.0.0.109") # Agrega tus 10 nombres/IPs

# 2. Bloque de código a ejecutar en cada servidor
$MonitorBlock = {
    try {
        # Obtenemos los eventos 4625 (Logon Failure)
        $Events = Get-WinEvent -FilterHashtable @{
            LogName = 'Security'
            Id      = 4625
        } -ErrorAction Stop

        foreach ($Event in $Events) {
            # Extraemos las ReplacementStrings (Propiedades del evento)
            $fields = $Event.Properties

            # Filtramos direcciones IP no deseadas (Localhost o vacío)
            $SourceIp = $fields[19].Value
            if ($SourceIp -eq "::1" -or $SourceIp -eq "-" -or $null -eq $SourceIp) {
                continue 
            }

            # Creamos el objeto con los campos mapeados (puedes añadir más si los necesitas)
            [PSCustomObject]@{
                Time       = $Event.TimeCreated
                Machine    = $fields[6].Value
                User       = $fields[5].Value
                Access     = $fields[10].Value
                SourceAddr = $SourceIp
                # Mapeo dinámico de los 25 campos si fuera necesario
                AllFields  = $fields.Value 
            }
        }
    }
    catch {
        Write-Warning "No se pudieron obtener eventos en $($env:COMPUTERNAME)"
    }
}

# 3. Ejecución simultánea
Write-Host "--- Iniciando recolección en $($Servidores.Count) servidores ---" -ForegroundColor Cyan

$ResultadosGlobales = Invoke-Command -ComputerName $Servidores -ScriptBlock $MonitorBlock -ErrorAction SilentlyContinue

# 4. Procesamiento de resultados centralizado
if ($ResultadosGlobales) {
    Write-Host "Consolidando datos y generando ranking de IPs..." -ForegroundColor Yellow

    # Agrupamos por IP de origen (SourceAddr)
    $ResumenIPs = $ResultadosGlobales | Group-Object -Property SourceAddr | Select-Object `
        @{Name='Intentos'; Expression={$_.Count}},
        @{Name='IP_Origen'; Expression={$_.Name}},
        @{Name='Servidores_Afectados'; Expression={($_.Group.PSComputerName | Select-Object -Unique) -join ", "}} |
        Sort-Object Intentos -Descending

    # Mostramos el resultado final
    $ResumenIPs | Format-Table -AutoSize
}
else {
    Write-Error "No se obtuvieron datos de ningún servidor."
}
