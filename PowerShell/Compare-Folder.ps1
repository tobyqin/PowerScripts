function Compare-Folder($base, $target, $log)
{
	Log-Info "Comparing Folder..." $log
    Log-Info "Base   <=: $base" $log
    Log-Info "Target =>: $target" $log    

    $b = Get-ChildItem -Recurse -path $base
    $t = Get-ChildItem -Recurse -path $target

    $hashAlgorithm = "MD5"
    $refDir = $difDir = @()
    $refFile = $difFile = @()
    $baseCount = $b.Count
    $targetCount = $t.Count
    
    if ($baseCount -ne $targetCount)
    {
        Log-Warn "$baseCount items in base folder." $log
        Log-Warn "$targetCount items in target folder." $log
        Log-Error "Counts are not equal!" $log
    }

    for($i = 0; $i -lt $baseCount; $i++)
    {
        $currentBaseItem = $b[$i]
         if($currentBaseItem.PSIsContainer)
        {
            $refDir += $currentBaseItem
        }
        else
        {
            $refFile += ($currentBaseItem | Select-Object Name, @{Name="Hash";Expression={(Get-FileHash $_.FullName -Algorithm $hashAlgorithm).Hash}})
        }

        $currentTargetItem = $t[$i]
         if($currentTargetItem.PSIsContainer)
        {
            $difDir += $currentTargetItem
        }
        else
        {
            $difFile += ($currentTargetItem | Select-Object Name, @{Name="Hash";Expression={(Get-FileHash $_.FullName -Algorithm $hashAlgorithm).Hash}})
        }
    }    

	Log-Info "1. Compare sub folders" $log	
	$result = Compare-Object -ReferenceObject $refDir -DifferenceObject $difDir

	if($result)
    {
        Log-Warn ("Failed! {0} folders are not equal." -f $result.InputObject.Count) $log
        $result
        $global:LASTEXITCODE = 5        
        Log-Error "Not equal!"        
    }
	else
	{
		Log-Info "Passed!" $log
		$result = $null
	}

	Log-Info "2. Compare file by hash" $log	
	Log-Info "Algorithm - $hashAlgorithm" $log

    $result = Compare-Object -ReferenceObject $refFile -DifferenceObject $difFile -Property Name, Hash

    if($result)
    {
        Log-Warn ("Failed! {0} files are not equal." -f $result.InputObject.Count) $log
        $result
        $global:LASTEXITCODE = 6     
        Log-Error "Not equal!"    
    }
    else
    {
        Log-Info "Passed!" $log
        $global:LASTEXITCODE = $null
		$result = $null
    }
}