Param (
    [Parameter(Mandatory=$true, Position=0, ParameterSetName='server')]
         [string] $server
    )


clear

#Variables TODO: add more to params

$SARSIS_Computers=""
$group_server_Choice=""
$tamano_grupo_reinicio=5
$maximo_errores_permitidos=2  
$prefix = ""    
$sleep=300 #Tiempo en segundos. Multiplos de 10

$MAD="MADSARSIS02","MADSARSIS03","MADSARSIS04","MADSARSIS05","MADSARSIS06","MADSARSIS07","MADSARSIS08","MADSARSIS09","MADSARSIS10","MADSARSIS11","MADSARSIS12","MADSARSIS16","MADSARSIS17","MADSARSIS18","MADSARSIS19","MADSARSIS20","MADSARSIS21"
$ALC="SARSISSRV020","SARSISSRV022","SARSISSRV023","SARSISSRV026","SARSISSRV027","SARSISSRV028","SARSISSRV029","SARSISSRV032","SARSISSRV033","SARSISSRV034","SARSISSRV035","SARSISSRV036","SARSISSRV037","SARSISSRV038","SARSISSRV039","SARSISSRV040","SARSISSRV041"
$ALL=$MAD+$ALC

do
{
    if ($server -like '*SARSIS*')
        {
            $SARSIS_Computers=$server; $exit=$true; break;
        }else{
            switch($server){
 
                ALC {$SARSIS_Computers=$ALC; $exit=$true; break}
                MAD {$SARSIS_Computers=$MAD; $exit=$true; break}
                ALL {$SARSIS_Computers=$ALL; $exit=$true; break}
                default { 
                            Write-Host "ERROR: Grupo de servidores no introducido correctamente: $server " -ForegroundColor Red
                            $server=Read-Host -Prompt "Introduce el grupo de servidores (ALC, MAD, ALL o SERVERNAME)"                        
                        }
            }
        }

}until ($exit)

Write-Host "-------------------------------------------------------------------------------------------------------------------" -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- INICIANDO REINICIO DE DAEMONS SIS PARA LOS SERVIDORES: " -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- $SARSIS_Computers" -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host "-------------------------------------------------------------------------------------------------------------------`n" -ForegroundColor Cyan -BackgroundColor DarkBlue


$aproval=Read-Host -Prompt "Pulsa C para continuar"
while ( $aproval.ToUpper() -ne "C" ) 
{
            $aproval=Read-Host -Prompt "Pulsa C para continuar"           
}

$servers_ok=""
$servers_no_ok=""
$errores=0
$reiniciando=0

foreach ($computer in $SARSIS_Computers) {     
    
    if ( $errores -gt $maximo_errores_permitidos ) {
        Write-Host "ERROR: SE HA DETENIDO LA EJECUCIÓN DEL SCRIPT. DEMASIADOS ERRORES: $errores"
        Write-Host "Revise el reporte a continuación."
        [console]::beep(1500,1000)
        break
    }

    if ( $reiniciando -eq $tamaño_grupo_reinicio ) {
        $reiniciando=0
        $minutos_totales=$sleep/60
        Write-Host "* Esperando $minutos_totales minutos " -ForegroundColor Gray -NoNewline
        $min=0
            
        for ($i=1; $i -le ($sleep / 10); $i++ ) {
            Write-Host "."  -ForegroundColor Gray -NoNewline
            sleep 10
            if ( $i % 6 -eq 0 ) {
                $min++
                Write-Host "($min)" -NoNewline
            }
        }
        Write-Host "`n`n"
    }

    # Comprobación1: Conexión con el servidor
    Write-Host "$computer : Check [1/3] - Conexión con el servidor" -NoNewline

    if ( !(Test-Connection -BufferSize 32 -Count 1 -ComputerName $computer -Quiet) ) { 
        $mensaje="NO SE PUDO CONECTAR CON EL SERVIDOR"
        Write-Host "`nERROR: $mensaje $computer" -ForegroundColor Red
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        [console]::beep(1900,300)
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        $errores++        
        continue 
    }
    Write-Host " [OK]"

    # Comprobación2: CheckerDaemons debe estar ACTIVO
    $process_checker="CheckerDaemons"
    Write-Host "$computer : Check [2/3] - $process_checker" -NoNewline    
    $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_checker}

    if ( !$process ) {
        $mensaje="EL DAEMON $process_checker NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
        Write-Host "`nWARNING: $mensaje $computer" -ForegroundColor Yellow
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        [console]::beep(1900,300)
        $errores++
        continue
    } 
    Write-Host " [OK]"

    # Comprobación3: SIS debe estar corriendo en la máquina
    $process_sis="SARSISDWebServer"
    Write-Host "$computer : Check [3/3] - $process_sis" -NoNewline    
    $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_sis}
    
    if ( !$process ) {
        $mensaje="EL DAEMON $process_sis NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
        Write-Host "`nWARNING: $mensaje $computer" -ForegroundColor Yellow
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        [console]::beep(1900,300)
        $errores++
        continue
    } 
    Write-Host " [OK]"

    # Finalizamos el SIS
    $process_exe="SARSISDWebServer.exe"
    $process=Get-WmiObject -Class Win32_Process -ComputerName $computer -Filter "name='$process_exe'"
    $t=Get-Date -UFormat "%H:%M:%S"

    if ( $process.terminate() ) {    
        $reiniciando++            
        Write-Host "$t - Reiniciando daemon $process_sis en $computer " -ForegroundColor DarkYellow -NoNewline
                
        for ($i=1; $i -le 15; $i++ ) {
            Write-Host "."  -ForegroundColor DarkYellow -NoNewline
            sleep 1            
        }
        Write-Host " [OK]" -ForegroundColor DarkYellow

        $t=Get-Date -UFormat "%H:%M:%S"
                
        if ( ( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_sis} ) {
            Write-Host "$t - Daemon reiniciado correctamente en $computer `n`r" -ForegroundColor Green
            $servers_ok=$servers_ok+$t+" - "+$computer+"`n`r"
            sleep 5
        } else {
            $mensaje="$t - NO SE HA DETECTADO EL DAEMON $process_sis TRAS FINALIZARLO"
            Write-Host "`nERROR: $mensaje EN $computer" -ForegroundColor Red
            [console]::beep(1900,300)
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        }
    } else {
        $mensaje="$t - NO SE HA PODIDO FINALIZAR EL DAEMON $process_sis "
        Write-Host "ERROR: $mensaje EN $computer" -ForegroundColor Red
        [console]::beep(1900,300)
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
    }       

}
  
Write-Host ""
Write-Host " **************** REPORTE ******************** `n`r" -ForegroundColor DarkBlue -BackgroundColor Gray
Write-Host "- Daemons reiniciados correctamente: "
Write-Host "$servers_ok"
Write-Host "Errores: $errores `n`r"
Write-Host "- DAEMONS NO REINICIADOS: "
Write-Host "$servers_no_ok" -ForegroundColor Red
Write-Host " *********************************************" -ForegroundColor DarkBlue -BackgroundColor Gray

