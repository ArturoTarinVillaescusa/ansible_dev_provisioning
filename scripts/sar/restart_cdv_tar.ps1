##CDV-TAR RESTART

clear


################################### TAR Pool MAD-ALC #######################################

#$Computers="MADSARSIS02","MADSARSIS03","MADSARSIS04","MADSARSIS05","MADSARSIS06","MADSARSIS07","MADSARSIS08","MADSARSIS09","MADSARSIS10","MADSARSIS11","MADSARSIS12","MADSARSIS16","MADSARSIS17","MADSARSIS18","MADSARSIS19","MADSARSIS20","MADSARSIS21"

#$Computers="MADSARSIS02","MADSARSIS03","MADSARSIS04","MADSARSIS05","MADSARSIS06","MADSARSIS07","MADSARSIS08","MADSARSIS09","MADSARSIS10","MADSARSIS11","MADSARSIS12","MADSARSIS16","MADSARSIS17","MADSARSIS18","MADSARSIS19","MADSARSIS20","MADSARSIS21"
#$Computers=$Computers+"SARSISSRV020","SARSISSRV022","SARSISSRV023","SARSISSRV026","SARSISSRV027","SARSISSRV028","SARSISSRV029","SARSISSRV032","SARSISSRV033","SARSISSRV034","SARSISSRV035","SARSISSRV036","SARSISSRV037","SARSISSRV038","SARSISSRV039","SARSISSRV040","SARSISSRV041"

#$Computers="SARSISSRV036","SARSISSRV037"

################################### Pool MAD-ALC #######################################

############################# CDV Pool MAD with Location ###################################

#MAD

#$Computers="MADSARSIS02","MADSARSIS03","MADSARSIS21","MADSARSIS20","MADSARSIS04","MADSARSIS05","MADSARSIS19","MADSARSIS18"
#$Computers=$Computers+"MADSARSIS06","MADSARSIS07","MADSARSIS16","MADSARSIS17","MADSARSIS08","MADSARSIS09","MADSARSIS10"
#$Computers="MADSARSIS11","MADSARSIS12"

#ALC

$Computers="SARSISSRV020","SARSISSRV022","SARSISSRV040","SARSISSRV041","SARSISSRV023","SARSISSRV026","SARSISSRV038","SARSISSRV039","SARSISSRV027","SARSISSRV028","SARSISSRV034","SARSISSRV035","SARSISSRV029","SARSISSRV032"
#$Computers="SARSISSRV033","SARSISSRV036","SARSISSRV037"


############################# Pool MAD with Location ###################################

#$Computers= "MADSARSIS16","MADSARSIS17","MADSARSIS18","MADSARSIS19","MADSARSIS21"

<# $Computers="MADSARSIS04","MADSARSIS05","SARSISSRV034","SARSISSRV035",
            "MADSARSIS06","MADSARSIS07","SARSISSRV038","SARSISSRV039",
            "MADSARSIS08","MADSARSIS09","SARSISSRV040","SARSISSRV041",
            "MADSARSIS10","MADSARSIS11","SARSISSRV029","SARSISSRV032",
            "MADSARSIS12","SARSISSRV033","MADSARSIS16","MADSARSIS17"


$Computers=$Computers+"SARSISSRV020","SARSISSRV022","MADSARSIS18","MADSARSIS19",
                       "SARSISSRV023","SARSISSRV026","MADSARSIS20","MADSARSIS21",
                       "SARSISSRV027","SARSISSRV028"


$Computers="SARSISSRV038","SARSISSRV039",
            "MADSARSIS08","MADSARSIS09","SARSISSRV040","SARSISSRV041",
            "MADSARSIS10","MADSARSIS11","SARSISSRV029","SARSISSRV032",
            "MADSARSIS12","SARSISSRV033","MADSARSIS16","MADSARSIS17"


$Computers=$Computers+"SARSISSRV020","SARSISSRV022","MADSARSIS18","MADSARSIS19",
                       "SARSISSRV023","SARSISSRV026","MADSARSIS20","MADSARSIS21",
                       "SARSISSRV027","SARSISSRV028","SARSISSRV034","SARSISSRV035"


#>

$tamaño_grupo_reinicio=4
$sleep=150 #Tiempo en segundos. Multiplos de 10
$daemons="CDVSID"#,"TARSID"     

Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- INICIANDO REINICIO DE DAEMONS $daemons PARA LOS SERVIDORES: " -ForegroundColor Cyan -BackgroundColor DarkBlue
Write-Host "- $computers" -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" -ForegroundColor Cyan -BackgroundColor DarkBlue

$servers_ok=""
$bloque_servers=""
$servers_no_ok=""
$errores=0
$count=0
$minutos_totales=$sleep/60

foreach ($computer in $Computers) {    

    

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
        Write-Host "`nComprueba que los daemon $daemons de los servidores $bloque_servers" -BackgroundColor Cyan -ForegroundColor Black 
        Write-Host "están correctamente iniciados." -BackgroundColor Cyan -ForegroundColor Black
        Write-Host "`nMete en el pool los $daemons de los servidores $bloque_servers " -BackgroundColor Green -ForegroundColor Black
        $bloque_servers=""
    }
    
    $bloque_servers=$bloque_servers + " " + $computer
        
    # Sacar del pool el siguiente bloque
    if ( ($count -eq 0) -or (($count % $tamaño_grupo_reinicio) -eq 0) ) {
    
        Write-Host "`nSaca del pool los daemon $daemons de los servidores " -BackgroundColor Yellow -ForegroundColor Black  -NoNewline
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
    
    if ( $errores -gt 2 ) {
        echo "ERROR: SE HA DETENIDO LA EJECUCIÓN DEL SCRIPT. DEMASIADOS ERRORES: $errores"
        [console]::beep(1900,3000)
        echo "Revise el reporte a continuación."
        break
    }

    Write-Host "* $computer [$($count+1)/$($Computers.count)] -------------------------------------- *`n"  -ForegroundColor Gray    

    foreach ($daemon in $daemons) {

        # Comprobación1: Conexión con el servidor
        Write-Host "$computer : Check [1/3] - Conexión con el servidor .." -NoNewline

        if ( !(Test-Connection -BufferSize 32 -Count 1 -ComputerName $computer -Quiet) ) { 
            $mensaje="NO SE PUDO CONECTAR CON EL SERVIDOR"
            Write-Host "`nERROR: $mensaje $computer" -ForegroundColor Red
            Write-Host "Continuando con el siguiente servidor de la lista `n`r"
            [console]::beep(1900,300)
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
            $errores++ 
            Sleep 3       
            continue 
        }
        Write-Host " [OK]"

        # Comprobación2: CheckerDaemons debe estar ACTIVO
        $process_checker="CheckerDaemons"
        Write-Host "$computer : Check [2/3] - $process_checker  ..........." -NoNewline    
        $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $process_checker}

        if ( !$process ) {
            $mensaje="EL DAEMON $process_checker NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
            Write-Host "`nWARNING: $mensaje $computer" -ForegroundColor Yellow
            Write-Host "Continuando con el siguiente servidor de la lista `n`r"
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
            [console]::beep(1900,300)            
            Sleep 3
            continue
        } 
        Write-Host " [OK]"  

        # Comprobación3: CDV/TAR debe estar corriendo en la máquina
        $process=( Get-Process -ComputerName $computer ).Where{$_.Name -like $daemon}
        Write-Host "$computer : Check [3/3] - $daemon  ..................." -NoNewline    

        if ( !$process ) {
            $mensaje="EL DAEMON $daemon NO ESTÄ EN EJECUCIÓN EN EL SERVIDOR"
            Write-Host "WARNING: $mensaje $computer" -ForegroundColor Yellow
            Write-Host "Continuando con el siguiente servidor de la lista `n`r"
            [console]::beep(1900,300)
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"                        
            Sleep 3
            continue
        } 
        Write-Host " [OK]"

        # Finalizamos el Daemon
        $daemon_exe = $daemon+".exe"
        $process=Get-WmiObject -Class Win32_Process -ComputerName $computer -Filter "name='$daemon_exe'"
        $t=Get-Date -UFormat "%H:%M:%S"

        if ( $process.terminate() ) {                

            $t=Get-Date -UFormat "%H:%M:%S"
            Write-Host "$t - Reiniciando daemon $daemon en $computer ..." -ForegroundColor DarkYellow -NoNewline
            sleep 12  
                
            if ( ( Get-Process -ComputerName $computer ).Where{$_.Name -like $daemon} ) {
                Write-Host " [OK]`n" -ForegroundColor Green
                $servers_ok=$servers_ok+$t+" - "+$computer+" - "+$daemon+"`n`r"                
            } else {
                $mensaje="$t - NO SE HA DETECTADO EL DAEMON $daemon TRAS FINALIZARLO"
                Write-Host "`nERROR: $mensaje EN $computer" -ForegroundColor Red
                [console]::beep(1900,300)
                $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
                $errores++
            }
        } else {
            $mensaje="NO SE HA PODIDO FINALIZAR EL DAEMON $daemon "
            Write-Host "$t - ERROR: $mensaje EN $computer" -ForegroundColor Red
            [console]::beep(1900,300)
            $servers_no_ok=$servers_no_ok+$t+" - "+"$computer $mensaje"+"`n`r"
            $errores++ 
        }     
    }
      
    $count++   
    
    Write-Host "* -------------------------------------------------------- *`n"  -ForegroundColor Gray    
}


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

Write-Host "`nComprueba que los daemon $daemons de los servidores $bloque_servers" -BackgroundColor Green -ForegroundColor Black 
Write-Host "están correctamente iniciados." -BackgroundColor Green -ForegroundColor Black
Write-Host "`nMete en el pool los $daemons de los servidores $bloque_servers " -BackgroundColor Green -ForegroundColor Black

Write-Host "`n`n **************** REPORTE ******************** `n`r" -ForegroundColor DarkBlue -BackgroundColor Gray
echo "- Daemons $daemons reiniciados correctamente: "
echo "$servers_ok"
echo "Errores: $errores `n`r"

if ( $servers_no_ok.Length -ne 0 ) {
    echo "- DAEMONS $daemons NO REINICIADOS: "
    Write-Host "$servers_no_ok" -ForegroundColor Red
}

Write-Host " *********************************************" -ForegroundColor DarkBlue -BackgroundColor Gray
[console]::beep(1200,300)
[console]::beep(1200,300)
[console]::beep(1200,300)
