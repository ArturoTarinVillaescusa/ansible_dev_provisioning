if ( (Get-Process).where{$_.name -like 'java'} ) {
        $process=Get-WmiObject -Class win32_process -Filter "name='java.exe'"
        if ( !$process.terminate() ) {
                exit 0
        }
}

