function Log-Info($message, $toFile)
{
	$now = {Get-Date -f "HH:mm:ss"}
	$msg = "[INFO]{0} {1}" -f (&$now), $message
	
	if($toFile -ne $null -and (Test-Path $toFile))
	{
		$msg | Out-File $toFile -Append
	}

	Write-Debug $msg
}

function Log-Warn($message, $toFile)
{
	$now = {Get-Date -f "HH:mm:ss"}
	$msg = "[WARN]{0} {1}" -f (&$now), $message
	
	if($toFile -ne $null -and (Test-Path $toFile))
	{
		$msg | Out-File $toFile -Append
	}

	Write-Warning $msg
}

function Log-Error($message, $toFile)
{
	$now = {Get-Date -f "HH:mm:ss"}
	$msg = "[ERROR]{0} {1}" -f (&$now), $message
	
	if($toFile -ne $null -and (Test-Path $toFile))
	{
		$msg | Out-File $toFile -Append
	}

	Write-Error $msg
}