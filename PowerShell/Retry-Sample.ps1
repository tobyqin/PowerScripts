function Test-Retry ($retry=3)
{
    if($retry -gt 0)
    {
        "Retry $retry ..."
        $retry --
        Test-Retry $retry
    }        
}

Test-Retry