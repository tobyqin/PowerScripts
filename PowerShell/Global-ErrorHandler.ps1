$ErrorActionPreference="Stop"
$DebugPreference="Continue"
$emailTo="user@domain.com"
$emailCC="team@domain.com"
$From = "notification@domain.com"
$SmtpHost = "smtphost@domain.com"

trap
{
    # Trap might not work if you dot sourcing this script.
    # http://stackoverflow.com/questions/5077550/powershell-single-point-where-i-can-catch-all-exceptions
    
    Write-Debug "=== Enter trap ==="
    
    $funcName = (Get-PSCallStack)[1].Position.Text
    $detail =  $_ | Out-String
    
    Send-Error $funcName $detail
    throw "<<<Error occurred, please take a look!>>> `n$detail"
    
    Write-Debug "=== Exit trap ===="
}


function Send-Error ($functionName, $errorDetail)
{
    $subject="Function <{0}> was failed, please check" -f $functionName
    $emailBody = $errorDetail
    $message = "{0}`n=============`n{1}`n=============" -f $subject, $emailBody
    Write-Debug $message
    Send-Email $emailTo $emailCC $subject $emailBody
}


function Send-Email($to, $cc, $subject, $body)
{
    "Sending Email...`n"
    "To: " + $to
    "CC: " + $cc
    "Subject: " + $subject
    "Body: " + $body
    
    Send-MailMessage -From $From -Subject $subject -To $to -Cc $cc -Body $body -BodyAsHtml -SmtpServer $SmtpHost
    
    "`nDone."
}

function Foo-Bar
{
    Get-ChildItem "NO such place!"
}

Foo-Bar