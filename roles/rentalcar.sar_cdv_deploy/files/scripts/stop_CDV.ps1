if ( (Get-Process).where{$_.name -like 'CheckerDaemons'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='CheckerDaemons.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}

if ( (Get-Process).where{$_.name -like 'CDVSID'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='CDVSID.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}
