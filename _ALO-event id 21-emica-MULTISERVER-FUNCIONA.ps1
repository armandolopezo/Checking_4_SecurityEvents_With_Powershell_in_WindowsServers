<#
.SYNOPSIS
    Monitoreo de eventos ID 21 (RDP Logon Succeeded) en servidores remotos.
.DESCRIPTION
    Extrae inicios de sesión de RDP exitosos desde el log de TerminalServices-LocalSessionManager.
    Genera un reporte consolidado en el escritorio del usuario actual.
.EXAMPLE
    .\Get-RDPLogonReport.ps1
#>

# --- CONFIGURACIÓN ---
$Servidores = @("vm2xcalibur", "vm1dc", "serverhpg6", "ciscoserver", "vm4pruebas", "vm2dc")
$Timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$PathReporte = "$env:USERPROFILE\Desktop\Reporte_RDP_Event21_$Timestamp.txt"

# 1. Bloque de extracción (Ejecución remota)
$MonitorBlock = {
    try {
        # El Evento 21 vive en un log específico, no en 'Security'
        $LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"
        $Events = Get-WinEvent -FilterHashtable @{LogName=$LogName; Id=21} -ErrorAction Stop

        foreach ($Event in $Events) {
            # En el Evento 21:
            # User = [0], Session = [1], Source IP = [2]
            $UserData = $Event.Properties[0].Value
            $SourceAddr = $Event.Properties[2].Value

            if ($SourceAddr -ne "LOCAL" -and -not [string]::IsNullOrWhiteSpace($SourceAddr)) {
                [PSCustomObject]@{
                    User       = $UserData
                    SourceAddr = $SourceAddr
                    Time       = $Event.TimeCreated
                }
            }
        }
    }
    catch { 
        # Si el log está vacío o no accesible, devolvemos null de forma silenciosa
        return $null 
    }
}

# 2. Inicialización del contenedor del reporte
$ContenidoArchivo = @()
$EncabezadoGeneral = "REPORTE CONSOLIDADO RDP (EVENTO 21) - FECHA: $(Get-Date)"
$ContenidoArchivo += $EncabezadoGeneral
$ContenidoArchivo += "=" * 80

Write-Host "`n$EncabezadoGeneral" -ForegroundColor Cyan

# 3. Bucle de ejecución servidor por servidor
foreach ($srv in $Servidores) {
    $Divisor = "=" * 60
    $SubHeader = "`n$Divisor`n ANALIZANDO SERVIDOR: $($srv.ToUpper()) `n$Divisor"
    
    Write-Host $SubHeader -BackgroundColor DarkBlue -ForegroundColor White
    $ContenidoArchivo += $SubHeader

    try {
        # Ejecución del bloque de código en el servidor remoto
        $DatosServidor = Invoke-Command -ComputerName $srv -ScriptBlock $MonitorBlock -ErrorAction Stop

        if ($null -ne $DatosServidor) {
            # Agrupamos por IP y Usuario para dar un reporte útil
            $Resumen = $DatosServidor | Group-Object -Property SourceAddr, User | 
                Select-Object Count, 
                              @{Name="IP_Address"; Expression={$_.Values[0]}}, 
                              @{Name="User"; Expression={$_.Values[1]}} | 
                Sort-Object Count -Descending

            $TablaTexto = $Resumen | Format-Table -AutoSize | Out-String
            
            Write-Host $TablaTexto
            $ContenidoArchivo += $TablaTexto
            
            $ResumenOK = "[OK] Conexiones RDP identificadas en $srv : $($Resumen.Count)"
            Write-Host $ResumenOK -ForegroundColor Green
            $ContenidoArchivo += $ResumenOK
        }
        else {
            $MsgWarn = "No se encontraron eventos 21 (Logon) en $srv."
            Write-Warning $MsgWarn
            $ContenidoArchivo += "[WARN] $MsgWarn"
        }
    }
    catch {
        $MsgErr = "[ERROR] Error de conexión o permisos en $srv. Detalle: $($_.Exception.Message)"
        Write-Host $MsgErr -ForegroundColor Red
        $ContenidoArchivo += $MsgErr
    }
}

# 4. Exportación final
$ContenidoArchivo | Out-File -FilePath $PathReporte -Encoding utf8
Write-Host "`n" + ("*" * 60) -ForegroundColor Cyan
Write-Host "PROCESO FINALIZADO" -ForegroundColor Cyan
Write-Host "Reporte guardado en: $PathReporte" -ForegroundColor Yellow