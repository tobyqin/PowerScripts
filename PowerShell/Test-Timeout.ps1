$task1 = {
    Write-Host "Stopping process..."
    while($true)
    {
        Write-Host "." -NoNewline
        sleep -Seconds 2
    }
}

$task2 = {
Write-Host "Kill Process..."
Exit-PSSession
}

# by seconds
$timeout = 10

Write-Host "=> Start task1 ..."
$job1 = Start-Job $task1
Wait-Job -Job $job1 -Timeout $timeout

if($job1.State -eq "Running")
{
    Write-Warning "Timeout to wait for task1 in <$timeout> seconds..."
    Receive-Job -Job $job1
    Stop-Job $job1
    Remove-Job $job1
   
    Write-Host "`n=> Start task2 ..."
    Invoke-Expression "$task2"
}


