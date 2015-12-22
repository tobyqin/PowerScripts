trap {
    "Script trap entered: $_"
    # exit -1
    continue
}

$dir = Split-Path -Parent $PSCommandPath

"Current directory: $dir"

Remove-Module -Force "Test-Module"
Import-Module $dir

test-function


