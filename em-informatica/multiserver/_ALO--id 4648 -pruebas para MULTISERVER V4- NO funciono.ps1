<#
.SYNOPSIS
    Versión escalable del monitoreo de eventos 4648 para múltiples servidores.
.DESCRIPTION
    Ejecuta la lógica de mapeo de ReplacementStrings en paralelo y centraliza
    el conteo de IPs de origen.
#>

# 1. Lista de tus servidores

# $Servidores = @("vm4pruebas", "vm2xcalibur", "vm1dc", "vm2dc", "serverhpg6", "ciscoserver", "10.0.0.220", "10.0.0.109")
$Servidores = @("vm4pruebas", "serverhpg6")

$MonitorBlock = {
    # Usamos Try-Catch para que si un servidor falla, el script no se detenga
    try {
        # Obtener eventos (Lógica original de tu Get-EventLog)
        $result = Get-EventLog -LogName Security -InstanceId 4648 -ErrorAction Stop
        
        # En lugar de crear arreglos gigantes de 1.000.000 de elementos, 
        # procesamos y enviamos solo lo que necesitamos (Pipeline)
        foreach ($element in $result) {
            
            $TestAddr = $element.ReplacementStrings[12]

            # Tu lógica de filtrado de direcciones no deseadas
            if ($TestAddr -ne "::1" -and $TestAddr -ne "-") {
                
                # Creamos el objeto con tus campos exactos
                [PSCustomObject]@{
                    Time       = $element.TimeGenerated
                    Machine    = $element.ReplacementStrings[6]
                    User       = $element.ReplacementStrings[5]
                    Access     = $element.ReplacementStrings[10]
                    SourceAddr = $TestAddr
                    # Guardamos el nombre del servidor donde se encontró el evento
                    ServerName = $env:COMPUTERNAME 
                    # Puedes añadir más campos del 1 al 25 aquí si los necesitas
                    field19    = $element.ReplacementStrings[19]
                }
            }
        }
    # Aplicamos tu lógica de Group-Object y Sort-Object
    $SortedIPaddresses = $ResultadosGlobales | Group-Object -Property SourceAddr | 
        Select-Object Count, @{Name="IP_Address"; Expression={$_.Name}} | 
        Sort-Object -Property Count -Descending

    $SortedIPaddresses | Format-Table -AutoSize
    
    }
    catch {
        # Si un servidor no tiene eventos o falla el acceso
        return $null
    }
}

Write-Host "Iniciando recolección simultánea en servidores..." -ForegroundColor Cyan

# 2. Ejecución Remota (Aquí ocurre la magia del paralelismo)
foreach ($srv in $Servidores)
    {
    write-host "Servidor: $srv"
    # pause
    $ResultadosGlobales = Invoke-Command -ComputerName $srv -ScriptBlock $MonitorBlock -ErrorAction SilentlyContinue
    }
# 3. Procesamiento Centralizado (Ranking de IPs)
if ($null -ne $ResultadosGlobales) {
    # Write-Host "--- Ranking de Direcciones IP Detectadas ---" -ForegroundColor Yellow
   Write-Host ""
    # Aplicamos tu lógica de Group-Object y Sort-Object
    # $SortedIPaddresses = $ResultadosGlobales | Group-Object -Property SourceAddr | 
    #    Select-Object Count, @{Name="IP_Address"; Expression={$_.Name}} | 
    #    Sort-Object -Property Count -Descending

    # $SortedIPaddresses | Format-Table -AutoSize
}
else {
    Write-Warning "No se recibieron datos. Verifica permisos o conexión WinRM."
}