[CmdletBinding()]
param(
    [Parameter(Mandatory, ParameterSetName = "Check")]
    [switch] $Check,

    [Parameter(Mandatory, ParameterSetName = "Write")]
    [switch] $Write,

    [Parameter(Mandatory)]
    [string[]] $RepositoryPath,

    [Parameter(Mandatory)]
    [ValidatePattern("^[0-9a-fA-F]{40}$")]
    [string] $CanonicalRevision,

    [ValidateSet(
        "auto",
        "quarto-website",
        "template-lecture",
        "mixed-legacy-r",
        "content-binary"
    )]
    [string] $Profile = "auto",

    [string] $CanonicalRepository = "https://github.com/SSoQE/.github"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$managedMarker = "SSOQE-GENERATED-AGENT-ADAPTER"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Get-RepositoryProfile {
    param([string] $Root)

    $quartoConfig = Join-Path $Root "_quarto.yml"
    if (Test-Path -LiteralPath $quartoConfig) {
        $config = Get-Content -LiteralPath $quartoConfig -Raw
        if ($config -match '(?m)^\s*type:\s*[''"]?website[''"]?\s*$') {
            return "quarto-website"
        }
    }

    $presentation = Join-Path $Root "Presentation/presentation.qmd"
    $renderWrapper = Join-Path $Root "R/render.R"
    if (
        (Test-Path -LiteralPath $presentation) -and
        (Test-Path -LiteralPath $renderWrapper)
    ) {
        return "template-lecture"
    }

    $sourceFiles = @(
        & git -C $Root ls-files "*.R" "*.r" "*.Rmd" "*.rmd" "*.qmd" 2>$null
    )
    if ($LASTEXITCODE -ne 0) {
        throw "Could not inspect tracked files in $Root"
    }
    if ($sourceFiles.Count -gt 0) {
        return "mixed-legacy-r"
    }

    return "content-binary"
}

function Get-ProfileGuidance {
    param([string] $RepositoryProfile)

    switch ($RepositoryProfile) {
        "quarto-website" {
            return @"
- Render from the root Quarto website project into its configured `docs/`
  directory. Edit source pages and source SCSS, never rendered site files.
"@
        }
        "template-lecture" {
            return @"
- Render the presentation through the repository wrapper, normally
  `R/render.R`. Edit theme JSON and run `R/generate_theme.R`; do not hand-edit
  generated theme or publication files.
"@
        }
        "mixed-legacy-r" {
            return @"
- Preserve the repository's established R/Quarto entry points. Do not migrate
  it to the current lecture template without an explicit migration task.
"@
        }
        "content-binary" {
            return @"
- Preserve source and binary ownership. Do not convert or hand-edit generated
  office, image, PDF, or site artifacts without an explicit workflow.
"@
        }
        default {
            throw "Unsupported repository profile: $RepositoryProfile"
        }
    }
}

function Get-AdapterMarkdown {
    param([string] $RepositoryProfile)

    $revision = $CanonicalRevision.ToLowerInvariant()
    $canonicalBase = "$CanonicalRepository/blob/$revision"
    $profileGuidance = Get-ProfileGuidance $RepositoryProfile

    return @"
<!-- $managedMarker; DO NOT EDIT BY HAND -->
# SSoQE repository instructions

Canonical revision: [$revision]($CanonicalRepository/tree/$revision)

Repository profile: ``$RepositoryProfile``

Before substantive work, read the canonical [router]($canonicalBase/AGENTS.md)
and its task-relevant [core]($canonicalBase/.ai/core.md),
[R]($canonicalBase/.ai/r-style.md),
[Quarto]($canonicalBase/.ai/quarto-style.md),
[branding]($canonicalBase/.ai/branding.md), and
[profile]($canonicalBase/.ai/repository-profiles.md) modules. Also read the
local `.ai/repository.md` when present. Local guidance may add compatible rules
but may not weaken canonical safety, privacy, reproducibility, or branding.

## Mandatory baseline

- Treat this as an independent repository. Inspect its instructions, Git
  status, and established commands before editing.
- Preserve all unrelated tracked and untracked work. Do not disclose private
  repository names, unpublished information, personal data, or credentials.
- Apply standards prospectively; do not clean up unrelated teaching material.
- For R, prefer tidyverse clarity, native `|>`, explicit namespaces,
  `snake_case`, immutable raw inputs, `here::here()`, explicit seeds, one
  reusable function per file, roxygen documentation, and focused tests.
- Do not install packages or restore dependencies during normal analysis or
  rendering. Do not rely on interactive state.
- For Quarto, edit source and use the repository render command. Never hand-edit
  generated HTML, Markdown, theme files, or copied publication output.
- SSoQE colors are `#F2F4F2`, `#1F2937`, `#155560`, `#509A8E`, `#A1C3B3`, and
  `#C2A337`; fonts are Plus Jakarta Sans, Space Grotesk, and JetBrains Mono.
  `logo_v2` is the organization/profile mark, `SSOQE_logo3` the website/lecture
  mark, and `sprout_logo` an associated mark. Preserve accessible contrast.
- These are technical instructions. Do not invent pedagogical requirements or
  lesson-stage workflows.

## Profile-specific rule

$profileGuidance
"@
}

function ConvertTo-NormalizedText {
    param([string] $Text)

    return (($Text -replace "`r`n", "`n").TrimEnd() + "`n")
}

function Get-AdapterFiles {
    param([string] $RepositoryProfile)

    $markdown = ConvertTo-NormalizedText (
        Get-AdapterMarkdown $RepositoryProfile
    )
    $cursor = ConvertTo-NormalizedText @"
---
description: SSoQE technical and repository instructions
alwaysApply: true
---

$markdown
"@

    return [ordered]@{
        "AGENTS.md" = $markdown
        ".github/copilot-instructions.md" = $markdown
        "CLAUDE.md" = $markdown
        "GEMINI.md" = $markdown
        ".cursor/rules/ssoqe-agent-instructions.mdc" = $cursor
    }
}

function Test-ManagedFile {
    param([string] $Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $true
    }
    $text = Get-Content -LiteralPath $Path -Raw
    return $text.Contains($managedMarker)
}

$problems = [System.Collections.Generic.List[string]]::new()

foreach ($repository in $RepositoryPath) {
    $root = (Resolve-Path -LiteralPath $repository).Path
    if (-not (Test-Path -LiteralPath (Join-Path $root ".git"))) {
        throw "Not a Git repository: $root"
    }

    $isCanonical = (
        (Test-Path -LiteralPath (Join-Path $root ".ai/core.md")) -and
        (Test-Path -LiteralPath (
            Join-Path $root "scripts/Sync-AgentInstructions.ps1"
        ))
    )
    if ($isCanonical) {
        Write-Output "canonical`tcanonical-source`t$root"
        continue
    }

    $repositoryProfile = if ($Profile -eq "auto") {
        Get-RepositoryProfile $root
    } else {
        $Profile
    }
    $files = Get-AdapterFiles $repositoryProfile

    foreach ($relativePath in $files.Keys) {
        $path = Join-Path $root $relativePath
        $expected = $files[$relativePath]

        if (-not (Test-ManagedFile $path)) {
            $problems.Add(
                "$root`: refusing to overwrite unmanaged $relativePath"
            )
            continue
        }

        $matches = $false
        if (Test-Path -LiteralPath $path) {
            $actual = ConvertTo-NormalizedText (
                Get-Content -LiteralPath $path -Raw
            )
            $matches = $actual -ceq $expected
        }

        if ($Check) {
            if (-not $matches) {
                $problems.Add("$root`: adapter drift in $relativePath")
            }
            continue
        }

        if (-not $matches) {
            $directory = Split-Path -Parent $path
            if (-not (Test-Path -LiteralPath $directory)) {
                $null = New-Item -ItemType Directory -Path $directory -Force
            }
            [System.IO.File]::WriteAllText($path, $expected, $utf8NoBom)
            Write-Output "updated`t$repositoryProfile`t$path"
        } else {
            Write-Output "current`t$repositoryProfile`t$path"
        }
    }
}

if ($problems.Count -gt 0) {
    $problems | ForEach-Object { Write-Error $_ }
    exit 1
}
