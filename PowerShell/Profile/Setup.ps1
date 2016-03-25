# Will copy the profile script to local folder
# Example: C:\Users\Toby\Documents\WindowsPowerShell

$ps = "Microsoft.PowerShell_profile.ps1"
$ise = "Microsoft.PowerShellISE_profile.ps1"

function Copy-Profile ($file)
{
    $from = Join-Path $PSScriptRoot $file
    $to = Join-Path (Get-Item $profile).Directory $file
    Copy-Item $from $to -Force
}

if(Test-Path (Join-Path (Get-Item $profile).Directory $ps))
{
    $key = Read-Host -Prompt "Overwrite existed PS profile? Y/N"
    if($key -match "y")
    {
        Copy-PsProfile $ps
    }
}
else
{
    Copy-PsProfile
}

if(Test-Path (Join-Path (Get-Item $profile).Directory $ise))
{
    $key = Read-Host -Prompt "Overwrite existed ISE profile? Y/N"
    if($key -match "y")
    {
        Copy-PsProfile $ise
    }
}
else
{
    Copy-PsProfile
}

Write-Host "Completed, restart your PowerShell sessions to take effect."
Write-Host "Good Bye."
Start-Sleep -Seconds 5

