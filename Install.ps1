#Requires -Version 7.0
[CmdletBinding()]
param(
    [string]$SkillsPath,
    [switch]$ReplaceExisting,
    [string]$BackupPath
)
$ErrorActionPreference = 'Stop'
$sourceRoot = Join-Path $PSScriptRoot 'skills'
$names = @('product-site-suite', 'product-project-bootstrap', 'shopify-product-site-factory')
$profilePath = [Environment]::GetFolderPath('UserProfile')
$explicitTarget = -not [string]::IsNullOrWhiteSpace($SkillsPath)
if (-not $explicitTarget) { $SkillsPath = Join-Path $profilePath '.agents/skills' }
if (-not $explicitTarget) {
    $legacyCandidate = Join-Path $profilePath '.codex/skills'
    $legacyFound = @($names | Where-Object { Test-Path -LiteralPath (Join-Path $legacyCandidate $_) })
    $modernFound = @($names | Where-Object { Test-Path -LiteralPath (Join-Path $SkillsPath $_) })
    if ($legacyFound.Count -and $modernFound.Count) { throw 'Bundle skills are split across .agents and .codex. Consolidate before installing; relative dependencies require one root.' }
    if ($legacyFound.Count) { $SkillsPath = $legacyCandidate }
}
if (-not $BackupPath) { $BackupPath = Join-Path $profilePath '.agents/skill-backups' }
function Full([string]$p) { [IO.Path]::GetFullPath($p).TrimEnd('\','/') }
function IsChild([string]$p,[string]$parent) {
    (Full $p).StartsWith((Full $parent) + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)
}
if (-not [IO.Path]::IsPathFullyQualified($SkillsPath) -or -not [IO.Path]::IsPathFullyQualified($BackupPath)) { throw 'Install and backup paths must be absolute.' }
$SkillsPath = Full $SkillsPath
$BackupPath = Full $BackupPath
if ($SkillsPath -eq (Full ([IO.Path]::GetPathRoot($SkillsPath))) -or $SkillsPath -eq (Full $profilePath)) { throw 'Choose a dedicated skills directory.' }
# Validate the complete package before any installed files change.
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'checksums.json') -Raw | ConvertFrom-Json -AsHashtable
foreach ($entry in $manifest.GetEnumerator()) {
    $file = Full (Join-Path $PSScriptRoot $entry.Key)
    if (-not (IsChild $file $PSScriptRoot)) { throw 'Invalid checksum path.' }
    if (-not (Test-Path -LiteralPath $file -PathType Leaf) -or (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash -ne $entry.Value) { throw "Package checksum failed: $($entry.Key)" }
}
function TreeHash([string]$p) {
    $items = @{}
    Get-ChildItem -LiteralPath $p -File -Recurse | ForEach-Object { $items[[IO.Path]::GetRelativePath($p,$_.FullName)] = (Get-FileHash -LiteralPath $_.FullName).Hash }
    $items
}
$plan = @()
foreach ($name in $names) {
    $src = Join-Path $sourceRoot $name
    if (-not (Test-Path -LiteralPath (Join-Path $src 'SKILL.md'))) { throw "Missing skill: $name" }
    $targetRoot = $SkillsPath
    if (-not $explicitTarget) {
        $legacyRoot = Join-Path $profilePath '.codex/skills'
        $legacy = Join-Path $legacyRoot $name
        $modern = Join-Path $SkillsPath $name
        if ((Test-Path -LiteralPath $legacy) -and (Test-Path -LiteralPath $modern)) { throw "Duplicate installed locations for $name. Resolve before installing." }
        if (Test-Path -LiteralPath $legacy) { $targetRoot = Full $legacyRoot }
    }
    $dest = Full (Join-Path $targetRoot $name)
    if (-not (IsChild $dest $targetRoot)) { throw 'Target escaped skills root.' }
    $state = 'new'
    if (Test-Path -LiteralPath $dest) {
        if (-not (Test-Path -LiteralPath $dest -PathType Container)) { throw "Target is not a directory: $dest" }
        # Do not move junctions/symlinks or installations containing them.
        $links = @(Get-Item -LiteralPath $dest; Get-ChildItem -LiteralPath $dest -Recurse -Force) | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }
        if ($links) { throw "Target contains reparse points: $dest" }
        $a=TreeHash $src; $b=TreeHash $dest
        $same=$a.Count -eq $b.Count
        foreach ($key in $a.Keys) { if ($a[$key] -ne $b[$key]) { $same=$false } }
        $state=if($same){'identical'}else{'conflict'}
    }
    $plan += [pscustomobject]@{name=$name;source=$src;destination=$dest;root=$targetRoot;state=$state;backup=$null}
}
if (($plan.state -contains 'conflict') -and -not $ReplaceExisting) {
    $plan | Select-Object name,destination,state | ConvertTo-Json -Depth 4
    throw 'Existing skills differ. No skills changed. Use -ReplaceExisting only to replace with this bundle after backup.'
}
foreach ($item in $plan) {
    if ($item.state -eq 'identical') {continue}
    New-Item -ItemType Directory -Path $item.root -Force | Out-Null
    if ($item.state -eq 'conflict') {
        $backup = Full (Join-Path $BackupPath ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N') + '-' + $item.name))
        if (-not (IsChild $item.destination $item.root) -or -not (IsChild $backup $BackupPath) -or (IsChild $backup $item.destination)) { throw 'Unsafe backup target.' }
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        Move-Item -LiteralPath $item.destination -Destination $backup
        $item.backup=$backup
    }
    try { Copy-Item -LiteralPath $item.source -Destination $item.destination -Recurse }
    catch { throw "Install failed for $($item.name). Original backup: $($item.backup). Error: $_" }
    $a=TreeHash $item.source; $b=TreeHash $item.destination
    if($a.Count -ne $b.Count) {throw "File count mismatch: $($item.name)"}
    foreach($key in $a.Keys) {if($a[$key] -ne $b[$key]) {throw "Installed hash mismatch: $($item.name)/$key"}}
    $item.state='installed'
}
$plan | Select-Object name,destination,state,backup | ConvertTo-Json -Depth 4
