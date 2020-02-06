if ( (Get-Process).where{$_.name -like 'CheckerDaemons'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='CheckerDaemons.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}
