if ( (Get-Process).where{$_.name -like 'CheckerDaemons'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='CheckerDaemons.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}
if ( (Get-Process).where{$_.name -like 'SARSISDWebServer'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='SARSISDWebServer.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}
