function Send-Email($to, $cc, $subject, $body)
{
    $From = "you@domain.com"
    $SmtpHost = "smtp.domain.com"
    Send-MailMessage -From $From -Subject $subject -To $to -Cc $cc -Body $body -BodyAsHtml -SmtpServer $SmtpHost
}

$To = "user1@domain.com", "user2@domain.com"
$Cc="boss@domain.com"
$Subject = "Don't worry, it is a test."
$Body = ":-)"
Send-Email -to $To -cc $Cc -subject $Subject -body $Body