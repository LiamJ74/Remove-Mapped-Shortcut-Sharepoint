function Remove-Silent {
    param(
        [string]$Path
    )
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$baseKey = "HKCU:\Software\SyncEngines\Providers\OneDrive"
$sousDossiers = Get-ChildItem -Path $baseKey

foreach ($sousDossier in $sousDossiers) {
    $regPath = "HKCU:\Software\SyncEngines\Providers\OneDrive\$($sousDossier.PSChildName)"
    $isFolderScope = Get-ItemProperty -Path $regPath -Name "IsFolderScope" -ErrorAction SilentlyContinue

    if ($isFolderScope -and $isFolderScope.IsFolderScope -eq 1) {
        $mountPoint = Get-ItemProperty -Path $regPath -Name "MountPoint" -ErrorAction SilentlyContinue

        if ($mountPoint -and $mountPoint.MountPoint) {
            $folderPath = $mountPoint.MountPoint
            Write-Host "Suppression du dossier : $folderPath"
            Remove-Silent -Path $folderPath
        }
    }
}
