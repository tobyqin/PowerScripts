$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
function Get-Hash($filePath, $retry=3)
{
	$stream = [System.IO.File]::Open("$filePath",[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)	
	$hash = [System.BitConverter]::ToString($md5.ComputeHash($stream))
	$stream.Close()

	if([System.String]::IsNullOrEmpty($hash) -and ($retry -gt 0))
	{
		Log-Info "Failed to get hash for file: '$filePath', retry $retry.."
		$retry --
		$hash = Get-Hash $filePath $retry
	}

	$hash
}

function Compare-Folder($base, $target, $log)
{
	Log-Info "Comparing Folder..." $log
    Log-Info "Base   <=: $base" $log
    Log-Info "Target =>: $target" $log    

    $b = Get-ChildItem -Recurse -path $base
    $t = Get-ChildItem -Recurse -path $target
	if($b -eq $null){$b = @()}
	if($t -eq $null){$t = @()}    

    $baseCount = $b.Count
    $targetCount = $t.Count
	$isPassed = $true

	Log-Info "$baseCount items in base folder." $log
    Log-Info "$targetCount items in target folder." $log
    
	# Compare count and return not equal files
    if ($baseCount -ne $targetCount)
    {
		$isPassed = $false		
		$out = Compare-Object $b $t -Property Name -PassThru			
		Log-Warn ("{0} files are not equal" -f $out.Count) $log	
		$detail = $out | Select-Object FullName, LastWriteTime, SideIndicator | Format-List | Out-String
		Log-Warn $detail $log
		# Exit, no need to do more compare      
        Log-Error "Failed!" 
    }

	# For folder comparing, we just care on name	
	Log-Info "1. Compare sub folders" $log	
	$left = $b | Where-Object {$_.PSIsContainer}
	$right = $t | Where-Object {$_.PSIsContainer}
	if($left -eq $null){$left = @()}
	if($right -eq $null){$right = @()}
	$result = Compare-Object -ReferenceObject $left -DifferenceObject $right -PassThru

	if($result)
    {
        Log-Warn ("{0} folders are not equal" -f $result.Count) $log
        $detail = $result | Select-Object FullName, LastWriteTime, SideIndicator | Format-List | Out-String
		Log-Warn $detail $log
        $global:LASTEXITCODE = 5
		$isPassed = $false
		
		# Exit, no need to do more compare      
        Log-Error "Failed!"        
    }
	else
	{
		Log-Info "Passed!" $log
		$result = $null
	}

	# For file comparing, we care more attributes
	Log-Info "2. Compare file by Length, LastWriteTime" $log
	$left = $b | Where-Object {!$_.PSIsContainer}
	$right = $t | Where-Object {!$_.PSIsContainer}
	if($left -eq $null){$left = @()}
	if($right -eq $null){$right = @()}
    $result = Compare-Object -ReferenceObject $left -DifferenceObject $right -Property Name, Length, LastWriteTime -PassThru

    if($result)
    {						
		$left = $result | Where-Object {$_.SideIndicator -eq '<='} | Sort-Object FullName
		$right = $result | Where-Object {$_.SideIndicator -eq '=>'}	| Sort-Object FullName	
		
		Log-Warn ("{0} files are not equal from base" -f $left.Count) $log
		Log-Warn ("{0} files are not equal from target" -f $right.Count) $log
		Log-Warn "Double check by MD5 hash..." $log		
					
		for($i = 0; $i -lt $left.Count; $i++)
		{
			$currentFileA = $left[$i] | Select-Object Name, FullName, Length, LastWriteTime, @{Name="Hash";Expression={Get-Hash $_.FullName}}
			$currentFileB = $right[$i] | Select-Object Name, FullName, Length, LastWriteTime, @{Name="Hash";Expression={Get-Hash $_.FullName}}
			$out = Compare-Object $currentFileA $currentFileB -Property Name, Hash -PassThru
			if($out)
			{
				$detail = $out | Select-Object FullName, Length, LastWriteTime, Hash, SideIndicator | Format-List | Out-String
				Log-Warn $detail $log
				$isPassed = $false					
			}
		}						
    }
    
	if($isPassed)
	{
		Log-Info "Passed!" $log
	}
	else
	{
		$global:LASTEXITCODE = 6     
		Log-Error "Not equal!"
	}
}