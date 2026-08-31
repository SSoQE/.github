# Repository profiles and generated files

The synchronization tool assigns the first matching profile.

## 1. Quarto website

Detection: root `_quarto.yml` declares a website project.

- Treat the root Quarto configuration and source pages as authoritative.
- Render to the configured output directory, currently normally `docs/`.
- Apply website branding through its source SCSS rather than lecture themes.

## 2. Template-derived lecture

Detection: both `Presentation/presentation.qmd` and `R/render.R` exist.

- Use the repository render wrapper and generated-theme workflow.
- Preserve the presentation and GitHub Pages output-copy contract.
- Apply strict R, Quarto, and branding guidance to changed source.

## 3. Mixed or legacy R

Detection: the repository contains R, R Markdown, or Quarto source but does not match a profile above.

- Follow the repository's established entry points and publishing workflow.
- Do not migrate it to the current lecture template unless explicitly asked.
- Distinguish executable source from illustrative code embedded in material.

## 4. Content or binary

Detection: no earlier profile matches.

- Preserve source/binary ownership and avoid unnecessary conversion.
- Do not edit generated office, image, PDF, or site artifacts as though they were plain source files.

## Local overlay

`.ai/repository.md` is optional and repository-owned. It may define:

- verified setup, render, test, and publication commands;
- source/generated boundaries not discoverable from the standard profiles;
- ownership, licences, privacy constraints, or intentional brand deviations;
- repository-specific conventions that do not weaken canonical requirements.
