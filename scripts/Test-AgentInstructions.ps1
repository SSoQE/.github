[CmdletBinding()]
param(
    [string] $CanonicalRoot = (Split-Path -Parent $PSScriptRoot),
    [string] $WorkspaceRoot = (Split-Path -Parent $CanonicalRoot),
    [switch] $CheckPrivateNames
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([string] $Message)
    $failures.Add($Message)
}

$requiredFiles = @(
    "AGENTS.md",
    ".ai/core.md",
    ".ai/r-style.md",
    ".ai/quarto-style.md",
    ".ai/branding.md",
    ".ai/repository-profiles.md",
    ".ai/repository.md",
    ".github/copilot-instructions.md",
    "CLAUDE.md",
    "GEMINI.md",
    ".cursor/rules/ssoqe-agent-instructions.mdc",
    "scripts/Sync-AgentInstructions.ps1",
    "scripts/Get-ActiveSSoQERepositories.ps1",
    "scripts/Test-AgentInstructions.ps1"
)

$paths = foreach ($relativePath in $requiredFiles) {
    $path = Join-Path $CanonicalRoot $relativePath
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Failure "Missing required file: $relativePath"
    } else {
        $path
    }
}

foreach ($path in $paths) {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    if (
        $bytes.Length -ge 3 -and
        $bytes[0] -eq 0xEF -and
        $bytes[1] -eq 0xBB -and
        $bytes[2] -eq 0xBF
    ) {
        Add-Failure "UTF-8 BOM found: $path"
    }
    $text = [System.IO.File]::ReadAllText($path)
    if ($text.Contains([char]0xFFFD)) {
        Add-Failure "Unicode replacement character found: $path"
    }
}

$markdownPaths = @($paths | Where-Object { $_ -match "\.(md|mdc)$" })
foreach ($path in $markdownPaths) {
    $text = Get-Content -LiteralPath $path -Raw
    $matches = [regex]::Matches($text, "\[[^\]]+\]\(([^)]+)\)")
    foreach ($match in $matches) {
        $target = $match.Groups[1].Value
        if ($target -match "^(https?://|#|mailto:)") {
            continue
        }
        $targetPath = $target.Split("#")[0]
        $resolved = Join-Path (Split-Path -Parent $path) $targetPath
        if (-not (Test-Path -LiteralPath $resolved)) {
            Add-Failure "Broken local Markdown link in $path`: $target"
        }
    }
}

$scriptPaths = @($paths | Where-Object { $_ -match "\.ps1$" })
foreach ($path in $scriptPaths) {
    $tokens = $null
    $errors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile(
        $path,
        [ref] $tokens,
        [ref] $errors
    )
    foreach ($parseError in $errors) {
        Add-Failure "PowerShell parse error in $path`: $($parseError.Message)"
    }
}

$expectedColors = [ordered]@{
    white = "#F2F4F2"
    black = "#1F2937"
    midnightGreen = "#155560"
    persianGreen = "#509A8E"
    cambridgeBlue = "#A1C3B3"
    satinSheenGold = "#C2A337"
}
$expectedFonts = [ordered]@{
    body = "Plus Jakarta Sans"
    heading = "Space Grotesk"
    monospace = "JetBrains Mono"
}

$templateRoot = Get-ChildItem -LiteralPath $WorkspaceRoot -Directory |
    Where-Object {
        (Test-Path -LiteralPath (
            Join-Path $_.FullName "Presentation/colors.json"
        )) -and
        (Test-Path -LiteralPath (
            Join-Path $_.FullName "Presentation/fonts.json"
        )) -and
        (Test-Path -LiteralPath (
            Join-Path $_.FullName "R/generate_theme.R"
        ))
    } |
    Select-Object -First 1

if ($null -ne $templateRoot) {
    $colorPath = Join-Path $templateRoot.FullName "Presentation/colors.json"
    $fontPath = Join-Path $templateRoot.FullName "Presentation/fonts.json"
    $colors = Get-Content -LiteralPath $colorPath -Raw | ConvertFrom-Json
    $fonts = Get-Content -LiteralPath $fontPath -Raw | ConvertFrom-Json
    foreach ($entry in $expectedColors.GetEnumerator()) {
        if ($colors.primary.($entry.Key) -cne $entry.Value) {
            Add-Failure "Lecture color drift: $($entry.Key)"
        }
    }
    foreach ($entry in $expectedFonts.GetEnumerator()) {
        if ($fonts.($entry.Key) -cne $entry.Value) {
            Add-Failure "Lecture font drift: $($entry.Key)"
        }
    }
} else {
    Write-Warning "Lecture template not present; skipped JSON brand check"
}

$websiteStyle = Join-Path $WorkspaceRoot "SSoQE_website/styles.scss"
if (Test-Path -LiteralPath $websiteStyle) {
    $scss = Get-Content -LiteralPath $websiteStyle -Raw
    foreach ($value in $expectedColors.Values + $expectedFonts.Values) {
        if (-not $scss.Contains($value)) {
            Add-Failure "Website branding token missing: $value"
        }
    }
} else {
    Write-Warning "Website checkout not present; skipped SCSS brand check"
}

if ($CheckPrivateNames) {
    $repositories = & (Join-Path $PSScriptRoot `
        "Get-ActiveSSoQERepositories.ps1")
    $privateNames = @(
        $repositories |
            Where-Object { $_.isPrivate } |
            Select-Object -ExpandProperty name
    )
    $publicText = ($paths | ForEach-Object {
        [System.IO.File]::ReadAllText($_)
    }) -join "`n"
    foreach ($privateName in $privateNames) {
        if ($publicText.Contains($privateName)) {
            Add-Failure "Private repository name found in canonical files"
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "SSoQE agent-instruction validation passed."
