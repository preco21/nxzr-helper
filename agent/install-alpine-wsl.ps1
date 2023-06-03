Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-LatestGitHubReleaseBinary {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Repo,
        [Parameter(Mandatory)]
        [string]$Dir
    )
    $releases = "https://api.github.com/repos/$repo/releases"
    Write-Host "> Determining latest release from $Repo"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $latest_release = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)[0];
    $tag = $latest_release.tag_name
    $asset = $latest_release.assets[0]
    $asset_name = $asset.name
    $download_url = "https://github.com/$repo/releases/download/$tag/$asset_name"
    Write-Host "> Downloading binary from the latest release - $asset_name at $tag"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $outpath = Join-Path $Dir $asset_name
    Invoke-WebRequest $download_url -Out $outpath
    return $outpath
}

Write-Host "> This script will automatically download and unzip `"AlpineWSL`" project..."

$working_dir = [System.Environment]::CurrentDirectory
$staging_dir = (Join-Path $working_dir "staging")
if (-not (Test-Path -Path $staging_dir)) {
    New-Item -Path $working_dir -Name "staging" -ItemType "directory"
}

# Download and unzip `AlpineWSL`.
Write-Host "> Getting `"AlpineWSL`"..."
$alpine_wsl_zip = Get-LatestGitHubReleaseBinary -Repo "yuk7/AlpineWSL" -Dir $staging_dir
Expand-Archive $alpine_wsl_zip $staging_dir

# Install Alpine Linux.
Write-Host "> Installing the `"AlpineWSL`"..."
Start-Process -FilePath "$staging_dir\Alpine.exe" -NoNewWindow -Wait

# Removing the archive.
Remove-Item "$staging_dir\Alpine.zip"

Write-Host "> `"AlpineWSL`" is installed in the `"$staging_dir`" directory, to remove, you will need to run `".\Alpine.exe clean`" manually."
