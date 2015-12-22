function Load-Dll($dllName)
{
    [Reflection.Assembly]::LoadFrom($dllName) | Out-Null
    Write-Debug "  Loaded $dllName"
}

function Load-CruiseControlDll ($dllFolders)
{
    $ccDll=@("ThoughtWorks.CruiseControl.Core.dll","ThoughtWorks.CruiseControl.Remote.dll")
    
    foreach ($dir in $dllFolders)
    {
        if(Test-path $dir)
        {
            foreach ($dll in $ccDll)
            {
                $dll = Join-Path $dir $dll
                if(Test-path $dll)
                {
                    Load-Dll ($dll)
                }
            }
        }
    }
}

function Get-Client ($serverUrl)
{
    Write-Debug "Connecting to: $serverUrl"
    New-Object ThoughtWorks.CruiseControl.Remote.CruiseServerRemotingClient($serverUrl)
}

function ForeBuild-Project($projectName)
{
    $ccDir = @(
    "C:\Scripts"
    "C:\Program Files (x86)\CruiseControl.NET\server",
    "D:\Program Files (x86)\CruiseControl.NET\server")
    
    Load-CruiseControlDll $ccDir
    $client = get-client "tcp://localhost/:21234/CruiseManager.rem"
    
    "Now force building project: $projectName ..."
    
    $client.ForceBuild($projectName)
    $client.Dispose()
}

function Unit-Test
{    
    ForeBuild-Project "UAT.Deploy.ServerIntegrationTests"
}





