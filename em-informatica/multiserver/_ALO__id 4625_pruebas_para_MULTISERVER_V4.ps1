<#
.SYNOPSIS
    Monitoreo de eventos 4625 servidor por servidor con salida a archivo.
.DESCRIPTION
    Analiza fallos de login, muestra resultados en consola y guarda un reporte TXT.
#>

# --- CONFIGURACIÓN ---
$Servidores = @("vm2xcalibur","vm1dc","serverhpg6","ciscoserver","vm4pruebas","vm2dc")
# Genera una ruta en el escritorio con fecha y hora: Reporte_Eventos_20260227_0715.txt
$Timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$PathReporte = "$env:USERPROFILE\Desktop\Reporte_4625_$Timestamp.txt"

# 1. Bloque de extracción (Ejecución remota)
$MonitorBlock = {
    try {
        $result = Get-EventLog -LogName Security -InstanceId 4625 -ErrorAction Stop
        foreach ($element in $result) {
            # En el evento 4625, el índice 19 suele ser la Source Network Address
            $TestAddr = $element.ReplacementStrings[19]
            if ($TestAddr -ne "::1" -and $TestAddr -ne "-") {
                [PSCustomObject]@{
                    SourceAddr = $TestAddr
                    Time       = $element.TimeGenerated
                }
            }
        }
    }
    catch { return $null }
}

# 2. Inicialización del contenedor del reporte
$ContenidoArchivo = @()
$EncabezadoGeneral = "REPORTE CONSOLIDADO DE EVENTOS 4625 - FECHA: $(Get-Date)"
$ContenidoArchivo += $EncabezadoGeneral
$ContenidoArchivo += "=" * 70

Write-Host "`n$EncabezadoGeneral" -ForegroundColor Cyan

# 3. Bucle de ejecución servidor por servidor
foreach ($srv in $Servidores) {
    $Divisor = "=" * 60
    $SubHeader = "`n$Divisor`n ANALIZANDO SERVIDOR: $($srv.ToUpper()) `n$Divisor"
    
    # Salida a pantalla y acumulación para archivo
    Write-Host $SubHeader -BackgroundColor Blue -ForegroundColor White
    $ContenidoArchivo += $SubHeader

    try {
        $DatosServidor = Invoke-Command -ComputerName $srv -ScriptBlock $MonitorBlock -ErrorAction Stop

        if ($null -ne $DatosServidor) {
            $SortedIPs = $DatosServidor | Group-Object -Property SourceAddr | 
                Select-Object Count, @{Name="IP_Address"; Expression={$_.Name}} | 
                Sort-Object -Property Count -Descending

            # Convertimos la tabla visual en String para el archivo
            $TablaTexto = $SortedIPs | Format-Table -AutoSize | Out-String
            
            # Mostrar en consola
            Write-Host $TablaTexto
            
            # Acumular para el archivo
            $ContenidoArchivo += $TablaTexto
            $ResumenOK = "[OK] Total de IPs únicas encontradas en $srv : $($SortedIPs.Count)"
            Write-Host $ResumenOK -ForegroundColor Green
            $ContenidoArchivo += $ResumenOK
        }
        else {
            $MsgWarn = "No se encontraron eventos 4625 en $srv (o la IP era local/vacía)."
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

# 4. Guardar los datos acumulados en el archivo físico
$ContenidoArchivo | Out-File -FilePath $PathReporte -Encoding utf8
Write-Host "`n" + ("*" * 60) -ForegroundColor Cyan
Write-Host "PROCESO FINALIZADO" -ForegroundColor Cyan
Write-Host "Archivo guardado en: $PathReporte" -ForegroundColor Yellow