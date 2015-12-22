$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
function Get-Hash($filePath, $retry=3)
{
	$stream = [System.IO.File]::Open("$filePath",[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)	
	$hash = [System.BitConverter]::ToString($md5.ComputeHash($stream))
	$stream.Close()

	if([System.String]::IsNullOrEmpty($hash) -and ($retry -gt 0))
	{
        $DebugPreference = "Continue"
		Write-Debug "Failed to get hash for file: '$filePath', retry $retry.."
		$retry --
		$hash = Get-Hash $filePath $retry
	}

	$hash
}

$files = Get-ChildItem "C:\TFS" -Recurse | Where-Object {!$_.PSIsContainer}

"File counts: " + $files.Count

"Get Hash by .NET method"
Measure-Command{ $files | ForEach-Object {Get-Hash $_.FullName}}
# 6.08 seconds

"Get Hash by PowerShell V4 method"
Measure-Command{ $files | ForEach-Object {Get-FileHash $_.FullName -Algorithm MD5}}
# 14.94 seconds