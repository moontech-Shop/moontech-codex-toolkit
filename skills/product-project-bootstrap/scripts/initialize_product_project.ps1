#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectPath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProductName
)

$ErrorActionPreference = 'Stop'

if (-not [System.IO.Path]::IsPathFullyQualified($ProjectPath)) {
    throw 'ProjectPath must be an absolute path.'
}

$ProductName = $ProductName.Trim()
if ([string]::IsNullOrWhiteSpace($ProductName)) {
    throw 'ProductName cannot be blank.'
}

if ($ProductName.Length -gt 120) {
    throw 'ProductName is too long. Use 120 characters or fewer.'
}

$fullPath = [System.IO.Path]::GetFullPath($ProjectPath).TrimEnd('\', '/')
$pathRoot = [System.IO.Path]::GetPathRoot($fullPath).TrimEnd('\', '/')
$userRoot = [Environment]::GetFolderPath('UserProfile').TrimEnd('\', '/')

$broadRoots = [System.Collections.Generic.List[string]]::new()
@(
    $pathRoot,
    $userRoot,
    [Environment]::GetFolderPath('Desktop'),
    [Environment]::GetFolderPath('MyDocuments'),
    [Environment]::GetFolderPath('MyPictures'),
    [Environment]::GetFolderPath('MyMusic'),
    [Environment]::GetFolderPath('MyVideos'),
    (Join-Path $userRoot 'Downloads'),
    [Environment]::GetEnvironmentVariable('OneDrive')
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
    $broadRoots.Add([System.IO.Path]::GetFullPath($_).TrimEnd('\', '/'))
}

$isBroadPath = $false
foreach ($broadRoot in $broadRoots) {
    if ([System.StringComparer]::OrdinalIgnoreCase.Equals($fullPath, $broadRoot)) {
        $isBroadPath = $true
        break
    }
}

if ($isBroadPath) {
    throw 'ProjectPath is too broad. Provide a dedicated product-project folder.'
}

if ($ProductName.IndexOfAny([char[]]"`r`n") -ge 0) {
    throw 'ProductName must be one line.'
}

$directories = @(
    '00-总工作台',
    '00-总工作台\REQUESTS',
    '00-总工作台\HANDOFFS',
    '01-产品资料\01-原始资料',
    '01-产品资料\02-已核实事实',
    '01-产品资料\03-参考网站',
    '01-产品资料\04-素材原件',
    '02-品牌与共享设计\Logo',
    '02-品牌与共享设计\Fonts',
    '02-品牌与共享设计\Shared-assets',
    '03-Home页工作台\Research',
    '03-Home页工作台\Copy',
    '03-Home页工作台\Design',
    '03-Home页工作台\Assets',
    '03-Home页工作台\QA',
    '04-Product page工作台\Research',
    '04-Product page工作台\Copy',
    '04-Product page工作台\Design',
    '04-Product page工作台\Assets',
    '04-Product page工作台\QA',
    '05-网站开发\Theme',
    '05-网站开发\Integrations',
    '06-QA与发布\Evidence',
    '06-QA与发布\Releases',
    '99-归档'
)

$templateRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\assets\project-template'))
if (-not (Test-Path -LiteralPath $templateRoot -PathType Container)) {
    throw "Template folder is missing: $templateRoot"
}
$templateFiles = @(Get-ChildItem -LiteralPath $templateRoot -Recurse -File)

# Validate every required path before the first write so a type collision cannot
# leave a partially initialized scaffold.
if (Test-Path -LiteralPath $fullPath) {
    if (-not (Test-Path -LiteralPath $fullPath -PathType Container)) {
        throw "ProjectPath exists but is not a directory: $fullPath"
    }

    $requiredDirectorySet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($relativeDirectory in $directories) {
        $cursor = $relativeDirectory
        while (-not [string]::IsNullOrWhiteSpace($cursor)) {
            [void]$requiredDirectorySet.Add($cursor)
            $cursor = Split-Path -Parent $cursor
        }
    }
    foreach ($templateFile in $templateFiles) {
        $relativeFile = [System.IO.Path]::GetRelativePath($templateRoot, $templateFile.FullName)
        $cursor = Split-Path -Parent $relativeFile
        while (-not [string]::IsNullOrWhiteSpace($cursor)) {
            [void]$requiredDirectorySet.Add($cursor)
            $cursor = Split-Path -Parent $cursor
        }

        $destinationFile = Join-Path $fullPath $relativeFile
        if ((Test-Path -LiteralPath $destinationFile) -and -not (Test-Path -LiteralPath $destinationFile -PathType Leaf)) {
            throw "Expected a file but found another item: $destinationFile"
        }
    }
    foreach ($relativeDirectory in $requiredDirectorySet) {
        $destinationDirectory = Join-Path $fullPath $relativeDirectory
        if ((Test-Path -LiteralPath $destinationDirectory) -and -not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
            throw "Expected a directory but found another item: $destinationDirectory"
        }
    }
}

$createdDirectories = [System.Collections.Generic.List[string]]::new()
$preservedDirectories = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path -LiteralPath $fullPath)) {
    New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    $createdDirectories.Add($fullPath)
}

foreach ($relativeDirectory in $directories) {
    $destinationDirectory = Join-Path $fullPath $relativeDirectory
    if (Test-Path -LiteralPath $destinationDirectory -PathType Container) {
        $preservedDirectories.Add($relativeDirectory)
    }
    elseif (Test-Path -LiteralPath $destinationDirectory) {
        throw "Expected a directory but found another item: $destinationDirectory"
    }
    else {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        $createdDirectories.Add($relativeDirectory)
    }
}

$createdFiles = [System.Collections.Generic.List[string]]::new()
$preservedFiles = [System.Collections.Generic.List[string]]::new()
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$createdAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz')

foreach ($templateFile in $templateFiles) {
    $relativeFile = [System.IO.Path]::GetRelativePath($templateRoot, $templateFile.FullName)
    $destinationFile = Join-Path $fullPath $relativeFile
    if (Test-Path -LiteralPath $destinationFile -PathType Leaf) {
        $preservedFiles.Add($relativeFile)
        continue
    }
    elseif (Test-Path -LiteralPath $destinationFile) {
        throw "Expected a file but found another item: $destinationFile"
    }

    $destinationParent = Split-Path -Parent $destinationFile
    if (-not (Test-Path -LiteralPath $destinationParent)) {
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
    }

    $content = [System.IO.File]::ReadAllText($templateFile.FullName, [System.Text.Encoding]::UTF8)
    $content = $content.Replace('{{PRODUCT_NAME}}', $ProductName)
    $content = $content.Replace('{{PROJECT_PATH}}', $fullPath)
    $content = $content.Replace('{{CREATED_AT}}', $createdAt)
    [System.IO.File]::WriteAllText($destinationFile, $content, $utf8NoBom)
    $createdFiles.Add($relativeFile)
}

[ordered]@{
    schemaVersion = '2.0'
    mode = 'initialize-only'
    productName = $ProductName
    projectPath = $fullPath
    createdDirectories = @($createdDirectories)
    preservedDirectories = @($preservedDirectories)
    createdFiles = @($createdFiles)
    preservedFiles = @($preservedFiles)
} | ConvertTo-Json -Depth 5
