# Downloads the official Minecraft server jar for the version in minecraft-version.txt
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$Version = (Get-Content "minecraft-version.txt" -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($Version)) {
    throw "minecraft-version.txt is empty."
}

Write-Host "Downloading Minecraft server $Version..."

$Manifest = Invoke-RestMethod "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
$VersionMeta = $Manifest.versions | Where-Object { $_.id -eq $Version } | Select-Object -First 1
if (-not $VersionMeta) {
    throw "Version not found in manifest: $Version"
}

$VersionJson = Invoke-RestMethod $VersionMeta.url
$ServerUrl = $VersionJson.downloads.server.url

Invoke-WebRequest -Uri $ServerUrl -OutFile "server.jar"
$Size = (Get-Item "server.jar").Length / 1MB
Write-Host ("Saved server.jar ({0:N1} MB)" -f $Size)
