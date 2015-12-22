$DebugPreference = "Continue"
$ErrorActionPreference="Stop"

function Write-Log($logFile, $logInfo)
{
	$now = {Get-Date -f "yyyy-MM-dd HH:mm:ss"}
	$msg = "{0} {1}" -f (&$now), $logInfo
	
	if(Test-Path $logFile)
	{
		$msg | Out-File $logFile -Append
	}

	Write-Debug $msg
}

$log="C:\Test\test.txt"

Write-Log $log "Hello world!"