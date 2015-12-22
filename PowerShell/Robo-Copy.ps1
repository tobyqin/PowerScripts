function Robo-Copy($from, $to, $log)
{
    $tool = "robocopy"
    $args = "$from $to /MIR /MT:50 /R:0"
    Log-Info "Tool: '$tool'"
    Log-Info "Argument: '$args'"   

    Set-Location $env:TEMP
    $tempLog = [System.IO.Path]::GetTempFileName()
    Start-Process -FilePath $tool -ArgumentList $args -WindowStyle Hidden -Wait -RedirectStandardOutput $tempLog
    if($log)
    {
        Get-Content $tempLog -ReadCount 0 | Out-File $log -Append
    }
    else
    {
        Get-Content $tempLog -ReadCount 0
    }

    if($LastExitCode -ne $null)
    {
        Log-Info "Robocopy Exit Code: $LastExitCode" $log
    }
    Compare-Folder $from $to $log
}