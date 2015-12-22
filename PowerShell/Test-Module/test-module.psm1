   
function test-function
{
    Write-Warning $ErrorActionPreference
    "Hello, test-function!"
    bad-command
}


trap {
    "Module trap entered: $_"
    # exit -1
    continue
}


