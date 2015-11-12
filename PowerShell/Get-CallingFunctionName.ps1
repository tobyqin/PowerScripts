$ErrorActionPreference="Stop"
$DebugPreference="Continue"

trap
{
    Write-Debug "=== Enter trap ==="
    
    # C:\GitHub\PowerScripts\PowerShell\Get-CallingFunctionName.ps1
    #$MyInvocation.InvocationName
    
    # Get-CallingFunctionName.ps1
    #$MyInvocation.MyCommand.Name
    
    # Say-Hello
    #(Get-PSCallStack)[1].Position.Text
    
    $funcName = (Get-PSCallStack)[1].Position.Text
    $detail =  $_ | Out-String      
    
    Send-Error $funcName $detail
    throw "<<<Error occurred, please take a look!>>> `n$detail"
    
    Write-Debug "=== Exit trap ===="
}

function Send-Error ($functionName, $errorDetail)
{
    $message = "Function <{0}> was failed, please check. `n=============`n{1}`n=============" -f $functionName, $errorDetail
    Write-Debug $message
}

function Say-Hello
{
    echo "Hello!"
    bad-command
}

function Other-Action
{
    Write-Host "Something should not be run if error occurred!" -ForegroundColor Yellow
}

Say-Hello
Other-Action