Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

Write-Host "> This script will build a new agent image for NXZR..."

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

$alpine_exe = Join-Path $staging_dir "Alpine.exe"

# Run pre-installation setup.
Write-Host "> Running distro setup..."
$setup_script = Join-Path $PSScriptRoot "bt-setup.sh"
Start-Process -FilePath "$alpine_exe" -ArgumentList "runp `"$setup_script`"" -NoNewWindow -Wait

# Shutdown WSL for finalizing the setup.
Write-Host "> Shutting down WSL..."
wsl.exe --shutdown

Write-Host "> Wait for WSL to shutdown completely..."
# Wait for WSL to shutdown completely.
# Refers to the 8 seconds rule for more details: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#the-8-second-rule
Start-Sleep -Seconds 8

Write-Host "> Finished all installation steps, run `".\agent\extract-tar.ps1`" for archive extraction."
