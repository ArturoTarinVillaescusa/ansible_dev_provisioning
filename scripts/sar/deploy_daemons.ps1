### INSTALACION DE DAEMONS

clear

#POOL MADRID
#$Computers="MADSARSIS03","MADSARSIS04","MADSARSIS05","MADSARSIS06","MADSARSIS07","MADSARSIS08","MADSARSIS09","MADSARSIS10","MADSARSIS11","MADSARSIS12","MADSARSIS16","MADSARSIS17","MADSARSIS18","MADSARSIS19","MADSARSIS21"
#POOL ALICANTE
$Computers="SARSISSRV022","SARSISSRV023","SARSISSRV026","SARSISSRV034","SARSISSRV035","SARSISSRV027","SARSISSRV028","SARSISSRV029","SARSISSRV039","SARSISSRV041","SARSISSRV032","SARSISSRV033","SARSISSRV036","SARSISSRV037","SARSISSRV038"

#POOL PILOTO
#$Computers="SARSISSRV020","MADSARSIS20","SARSISSRV040","MADSARSIS02"

# Variables configurables
$computer_origin = "SARSISSRV020"
$tamaño_grupo_reinicio=5
$maximo_errores_permitidos=2      
$sleep=300 #Tiempo en segundos. Multiplos de 10
$daemon="SIS"

$process_checker="CheckerDaemons"

Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- INICIANDO INSTALACIÖN DE DAEMON $daemon EN LOS SERVIDORES: " -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- $Computers" -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------`n" -ForegroundColor Cyan -BackgroundColor DarkBlue
Read-Host -Prompt "Pulsa Intro para continuar"

$servers_ok=""
$servers_no_ok=""
$bloque_servers=""
$errores=0
$reiniciando=0
$count=0
$minutos_totales=$sleep/60

foreach ($computer in $Computers) {     

    if ( ($daemon -eq "CDV") -or ($daemon -eq "TAR") ) {
        
        # Meter en el pool bloque anterior
        if ( ($count -gt ($tamaño_grupo_reinicio-1) -and ($count % $tamaño_grupo_reinicio) -eq 0 ) -or ($count -eq $computers.Count) ) { 
            Write-Host "* Esperando $minutos_totales minutos ." -ForegroundColor Gray -NoNewline
            $min=0
                    
            for ($i=1; $i -le ($sleep/10); $i++ ) {
                Write-Host "."  -ForegroundColor Gray -NoNewline
                sleep 10
                if ( $i % 6 -eq 0 ) {
                    $min++
                    Write-Host "($min)" -NoNewline
                }
            }
            Write-Host " [OK]`n"  -ForegroundColor Gray
            [console]::beep(900,300)
            Write-Host "`nComprueba que los daemon $daemon de los servidores $bloque_servers" -BackgroundColor Cyan -ForegroundColor Black 
            Write-Host "están correctamente iniciados." -BackgroundColor Cyan -ForegroundColor Black
            Write-Host "`nMete en el pool los $daemon de los servidores $bloque_servers " -BackgroundColor Green -ForegroundColor Black
            $bloque_servers=""
        }
    
        $bloque_servers=$bloque_servers + " " + $computer
        
        # Sacar del pool el siguiente bloque
        if ( ($count -eq 0) -or (($count % $tamaño_grupo_reinicio) -eq 0) ) {
    
            Write-Host "`nSaca del pool los daemon $daemon de los servidores " -BackgroundColor Yellow -ForegroundColor Black  -NoNewline
            for ($i=0; $i -lt $tamaño_grupo_reinicio; $i++ ) {
                $server_pos=$count+$i
                #$s=Read-Host -Prompt "i = $i // count = $count // server_pos = $server_pos"
                Write-Host "$($computers[$server_pos]) " -BackgroundColor Yellow -ForegroundColor Black -NoNewline            
            }
            Write-Host " " -BackgroundColor Yellow -ForegroundColor Black
            $c=Read-Host -Prompt "Pulsa C para continuar"
        
            while ( $c.ToUpper() -ne "C" ) {
                $c=Read-Host -Prompt "Pulsa C para continuar"            
            }

            Write-Host "`nEsperando 15 segundos para sacar del pool..........`n`n"
            Sleep 15
        
        }
    }    
    
    if ( $errores -gt 2 ) {
        echo "ERROR: SE HA DETENIDO LA EJECUCIÓN DEL SCRIPT. DEMASIADOS ERRORES: $errores"
        [console]::beep(1900,3000)
        echo "Revise el reporte a continuación."
        break
    }

    Write-Host "* $computer [$($count+1)/$($Computers.count)] -------------------------------------- *`n"  -ForegroundColor Gray    

    
    # COMPROBAMOS SI SE HA ALCANZADO EL MAXIMO DE ERRORES PERMITIDOS
    if ( $errores -gt $maximo_errores_permitidos ) {
        Write-Host "ERROR: SE HA DETENIDO LA EJECUCIÓN DEL SCRIPT. DEMASIADOS ERRORES: $errores"
        Write-Host "Revise el reporte a continuación."
        [console]::beep(1500,1000)
        break
    }

    if ( $daemon -eq "SIS" ) {

        # COMPROBAMOS SI HEMOS ALCANZADO EL TAMAÑO DE BLOQUE DE REINICIO
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
    }

    # INICIALIZAMOS VARIABLES
    switch ($daemon) {
        "CDV" { 
                $process_daemon="CDVSID" ;
                $backup="\\$computer\c$\DAEMONS\CDVSID\BACKUP\" ;
                $origin_daemon="\\$computer_origin\c$\new_cdv\" ;                
                $path_daemon="\\$computer\c$\DAEMONS\CDVSID\" ;
              }
        "TAR" { 
                $process_daemon="TARSID" ;
                $backup="\\$computer\c$\DAEMONS\TARSID\BACKUP\" ;
                $origin_daemon="\\$computer_origin\c$\new_tar\" ;
                $path_daemon="\\$computer\c$\DAEMONS\TARSID\" ;
              }
        "SIS" { 
                $process_daemon="SARSISDWebServer" ; 
                $backup="\\$computer\c$\SARSISD\BACKUP\" ;
                #set-variable -Name "backup" -Value "\\$computer\c$\SARSISD\BACKUP\" -Scope Global 
                $origin_daemon="\\$computer_origin\c$\new_sarsis\" ;
                #set-variable -Name "origin_daemon" -Value "\\$computer_origin\c$\new_sarsis\*" -Scope Global
                $path_daemon="\\$computer\c$\SARSISD\" ;
                #set-variable -Name "SARSIS_path" -Value "\\$computer\c$\SARSISD\*" -Scope Global
              }
    }    

    # Comprobación: Existencia del fichero de origen
    $new_daemon_file="$origin_daemon"+"$process_daemon.exe"
    if ( !(Test-Path $new_daemon_file) ) {
        $mensaje="NO SE HA ENCONTRADO EL ARCHIVO ORIGEN $new_daemon_file"
        Write-Host "`nERROR: SE HA DETENIDO LA EJECUCION DEL SCRIPT.`nMOTIVO $mensaje" -ForegroundColor Red
        Write-Host "Revise el reporte a continuación."
        [console]::beep(1500,1000)
        break
    }

    # Comprobación1: Conexión con el servidor
    Write-Host "$computer : Check [1/3] - Conexión con el servidor .." -NoNewline

    if ( !(Test-Connection -BufferSize 32 -Count 1 -ComputerName $computer -Quiet) ) { 
        $mensaje="NO SE PUDO CONECTAR CON EL SERVIDOR"
        Write-Host "`nERROR: $mensaje $computer" -ForegroundColor Red
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        [console]::beep(1900,300)
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        $errores++        
        $count++
        continue 
    }
    Write-Host " [OK]"

    # Comprobación2: CheckerDaemons debe estar ACTIVO    
    Write-Host "$computer : Check [2/3] - $process_checker  ..........." -NoNewline    
    $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_checker}

    if ( !$process ) {
        $mensaje="EL DAEMON $process_checker NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
        Write-Host "`nWARNING: $mensaje $computer" -ForegroundColor Yellow
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        [console]::beep(1900,300)
        $errores++
        $count++
        continue
    } 
    Write-Host " [OK]"

    # Comprobación3: el daemon debe estar corriendo en la máquina    
    Write-Host "$computer : Check [3/3] - $process_daemon  ........." -NoNewline    
    $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_daemon}
    
    if ( !$process ) {
        $mensaje="EL DAEMON $process_daemon NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
        Write-Host "`nWARNING: $mensaje $computer" -ForegroundColor Yellow
        Write-Host "Continuando con el siguiente servidor de la lista `n`r"
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        [console]::beep(1900,300)
        $errores++
        $count++
        continue
    } 
    Write-Host " [OK]"

    ### TEST
    <#Write-Host "`n computer = $computer `n daemon = $daemon `n process_daemon = $process_daemon `n backup = $backup `n origin_daemon = $origin_daemon `n path_daemon = $path_daemon" -ForegroundColor Magenta
    Read-Host#>

    # * BACKUP *
    Write-Host "$computer : Realizando BACKUP........................" -NoNewline
    
    
    If( (test-path $backup) ) {
       Remove-Item -Path $backup -Recurse -Force      
    }
     
    New-Item -ItemType Directory -Path $backup -Force > $null
    Sleep 2
        
    copy-item -Path $path_daemon* -Destination $backup -Recurse -Exclude "BACKUP","BACKUP*.*","Logs","Log*"
    Write-Host " [OK]"
    
    # Actualizamos el daemon    
    Write-Host "$computer : Copiando archivos nuevos ................" -NoNewline
    Rename-Item -Path "$path_daemon\$process_daemon.exe" -NewName "$process_daemon.old"
    Sleep 2    
    Copy-Item -Path $origin_daemon* -Destination $path_daemon -Recurse -Force
    Write-Host " [OK]"
    
    # Finalizamos el daemon
    $process=Get-WmiObject -Class Win32_Process -ComputerName $computer -Filter "name='$process_daemon.exe'"
    $t=Get-Date -UFormat "%H:%M:%S"

    if ( $process.terminate() ) {    
        $reiniciando++            
        Write-Host "$t - Reiniciando daemon $process_daemon en $computer " -ForegroundColor DarkYellow -NoNewline
                
        for ($i=1; $i -le 15; $i++ ) {
            Write-Host "."  -ForegroundColor DarkYellow -NoNewline
            sleep 1            
        }
        Write-Host " [OK]" -ForegroundColor DarkYellow

        $t=Get-Date -UFormat "%H:%M:%S"
                
        if ( ( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_daemon} ) {
            Write-Host "$t - Daemon reiniciado correctamente en $computer `n`r" -ForegroundColor Green
            $servers_ok=$servers_ok+$t+" - "+$computer+"`n`r"
            sleep 5
        } else {
            $mensaje="$t - NO SE HA DETECTADO EL DAEMON $process_daemon TRAS FINALIZARLO"
            Write-Host "ERROR: $mensaje EN $computer `n`r" -ForegroundColor Red
            [console]::beep(1900,300)
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
            $errores++
            sleep 5
        }
        Remove-Item -Path "$path_daemon\$process_daemon.old" -Force
    } else {
        $mensaje="$t - NO SE HA PODIDO FINALIZAR EL DAEMON $process_daemon "
        Write-Host "ERROR: $mensaje EN $computer" -ForegroundColor Red
        [console]::beep(1900,300)
        $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
        $errores++
    }      
    $count++
}
  
Write-Host ""
Write-Host " **************** REPORTE ******************** `n`r" -ForegroundColor DarkBlue -BackgroundColor Gray
Write-Host "- Servidores desplegados correctamente: "
Write-Host "$servers_ok"
Write-Host "Errores: $errores `n`r"
Write-Host "- SERVIDORES NO DESPLEGADOS: "
Write-Host "$servers_no_ok" -ForegroundColor Red
Write-Host " *********************************************" -ForegroundColor DarkBlue -BackgroundColor Gray

