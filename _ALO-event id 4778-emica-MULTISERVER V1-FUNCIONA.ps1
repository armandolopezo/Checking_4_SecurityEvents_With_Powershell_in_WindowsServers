<#
.SYNOPSIS
    Monitoreo de eventos ID 4778 (Session Reconnected) en servidores remotos.
.DESCRIPTION
    Extrae reconexiones exitosas a sesiones de RDP desde el log de Seguridad.
    Útil para rastrear usuarios que retoman sesiones activas.
.EXAMPLE
    .\Get-RDPReconnectionReport.ps1
#>

# --- CONFIGURACIÓN ---
$Servidores = @("vm2xcalibur", "vm1dc", "serverhpg6", "ciscoserver", "vm4pruebas", "vm2dc")
$Timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$PathReporte = "$env:USERPROFILE\Desktop\Reporte_RDP_Reconexiones_4778_$Timestamp.txt"

# 1. Bloque de extracción (Ejecución remota)
$MonitorBlock = {
    try {
        # El Evento 4778 reside en el log de Security
        # Usamos Get-WinEvent por ser más eficiente que Get-EventLog en servidores modernos
        $Events = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4778} -ErrorAction Stop

        foreach ($Event in $Events) {
            # Mapeo de propiedades para el Evento 4778:
            # Account Name = [1], Client Name = [4], Client Address = [5]
            $AccountName = $Event.Properties[1].Value
            $ClientName  = $Event.Properties[4].Value
            $SourceAddr  = $Event.Properties[5].Value

            # Filtrar si la dirección está vacía o es local
            if ($SourceAddr -ne "-" -and $SourceAddr -ne "127.0.0.1" -and $SourceAddr -ne "::1") {
                [PSCustomObject]@{
                    User        = $AccountName
                    ClientNode  = $ClientName
                    SourceAddr  = $SourceAddr
                    Time        = $Event.TimeCreated
                }
            }
        }
    }
    catch { 
        return $null 
    }
}

# 2. Inicialización del contenedor del reporte
$ContenidoArchivo = @()
$EncabezadoGeneral = "REPORTE DE RECONEXIONES RDP (EVENTO 4778) - FECHA: $(Get-Date)"
$ContenidoArchivo += $EncabezadoGeneral
$ContenidoArchivo += "=" * 85

Write-Host "`n$EncabezadoGeneral" -ForegroundColor Cyan

# 3. Bucle de ejecución servidor por servidor
foreach ($srv in $Servidores) {
    $Divisor = "=" * 60
    $SubHeader = "`n$Divisor`n ANALIZANDO SERVIDOR: $($srv.ToUpper()) `n$Divisor"
    
    Write-Host $SubHeader -BackgroundColor DarkMagenta -ForegroundColor White
    $ContenidoArchivo += $SubHeader

    try {
        $DatosServidor = Invoke-Command -ComputerName $srv -ScriptBlock $MonitorBlock -ErrorAction Stop

        if ($null -ne $DatosServidor) {
            # Agrupamos por IP, Usuario y Nombre de la máquina cliente
            $Resumen = $DatosServidor | Group-Object -Property SourceAddr, User, ClientNode | 
                Select-Object Count, 
                              @{Name="IP_Address"; Expression={$_.Values[0]}}, 
                              @{Name="User"; Expression={$_.Values[1]}},
                              @{Name="Client_PC"; Expression={$_.Values[2]}} | 
                Sort-Object Count -Descending

            $TablaTexto = $Resumen | Format-Table -AutoSize | Out-String
            
            Write-Host $TablaTexto
            $ContenidoArchivo += $TablaTexto
            
            $ResumenOK = "[OK] Reconexiones identificadas en $srv : $($Resumen.Count)"
            Write-Host $ResumenOK -ForegroundColor Green
            $ContenidoArchivo += $ResumenOK
        }
        else {
            $MsgWarn = "No se encontraron eventos 4778 (Reconexión) en $srv."
            Write-Warning $MsgWarn
            $ContenidoArchivo += "[WARN] $MsgWarn"
        }
    }
    catch {
        $MsgErr = "[ERROR] No se pudo conectar a $srv. Detalle: $($_.Exception.Message)"
        Write-Host $MsgErr -ForegroundColor Red
        $ContenidoArchivo += $MsgErr
    }
}

# 4. Guardar reporte
$ContenidoArchivo | Out-File -FilePath $PathReporte -Encoding utf8
Write-Host "`n" + ("*" * 60) -ForegroundColor Cyan
Write-Host "PROCESO FINALIZADO" -ForegroundColor Cyan
Write-Host "Archivo guardado en: $PathReporte" -ForegroundColor Yellow