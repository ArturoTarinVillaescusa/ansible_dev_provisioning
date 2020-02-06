if ( (Get-Process).where{$_.name -like 'java'} ) {
	exit 0
}
else {
	exit 1
}

