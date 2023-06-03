Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "> This script will extract the final `.tar` archive..."

$working_dir = [System.Environment]::CurrentDirectory
$staging_dir = (Join-Path $working_dir "staging")
if (-not (Test-Path -Path $staging_dir)) {
    New-Item -Path $working_dir -Name "staging" -ItemType "directory"
}

if (-not (Test-Path -Path (Join-Path $staging_dir "ext4.vhdx"))) {
    Write-Error "> Failed to locate the distro to extract."
}

# Initiate extraction.
Write-Host "> Extracting distro package to `".tar`"..."
Start-Process -FilePath "$staging_dir\Alpine.exe" -ArgumentList "backup --tar" -NoNewWindow -Wait
Rename-Item -Path "$staging_dir\backup.tar" -NewName "nxzr-agent.tar"

Write-Host "> `"nxzr-agent.tar`" has been created at: `"$staging_dir`""
