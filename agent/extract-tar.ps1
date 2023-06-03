Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "> This script will extract the final `.tar` archive..."

$working_dir = [System.Environment]::CurrentDirectory
$staging_dir = (Join-Path $working_dir "staging")
if (-not (Test-Path -Path $staging_dir)) {
    New-Item -Path $working_dir -Name "staging" -ItemType "directory"
}

$base_distro_name = "Alpine"
$base_distro_not_exists = (wsl.exe --list --quiet) -notcontains $base_distro_name
if ($base_distro_not_exists) {
    Write-Error "> Failed to locate the base distro to extract."
}

# Initiate extraction.
Push-Location $staging_dir
Write-Host "> Extracting distro package to `".tar`"..."
Start-Process -FilePath "$staging_dir\Alpine.exe" -ArgumentList "backup --tar" -NoNewWindow -Wait
Rename-Item -Path "$staging_dir\backup.tar" -NewName "nxzr-agent.tar"
Pop-Location

Write-Host "> `"nxzr-agent.tar`" has been created at: `"$staging_dir`""
