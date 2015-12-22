$work1={
    Start-Sleep -Seconds 5
    "Do work 1 done."
}

$work2={
    Start-Sleep -Seconds 10
    "Do work 2 done."
}

cls
"-----------------------"
$jobs = @()
"Start-Job {0}" -f (Get-Date)
$jobs += Start-Job $work1
$jobs += Start-Job $work2

"-----------------------"
"Wait-Job {0}" -f (Get-Date)
#Wait for the background jobs
$jobs | Wait-Job

"-----------------------"
"Receive-Job {0}" -f (Get-Date)
#Get the data from them
$data = $jobs | Receive-Job
$data
"-----------------------"
"Remove-Job {0}" -f (Get-Date)
#Delete the jobs
$jobs | Remove-Job
"-----------------------"
