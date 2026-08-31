# Copilot instructions (SSoQE workspace)

This VS Code workspace is a collection of **independent course/lecture repos** (mostly R + Quarto) plus the public website repo.

## What is SSoQE?
- SSoQE (Science School on Quantitative Ecology) is a week-long intensive school (running since 2024) co-organised by Charles University in Prague (CZ) and the University of Bayreuth (GER).
- It targets Master’s and PhD students in ecology (or closely related fields) and focuses on quantitative ecology, modern data analysis, and reproducible research workflows in R.
- Source of truth for public-facing wording and schedule is the website content in [SSoQE_website/index.qmd](../SSoQE_website/index.qmd) and [SSoQE_website/About/general_info.qmd](../SSoQE_website/About/general_info.qmd).

## Big picture
- Each lecture repo is a self-contained RStudio project (`*.Rproj`) with:
  - Source: `Presentation/presentation.qmd` (slides) and often `R/Exercises/*.qmd` (exercise handouts)
  - Published output: `docs/index.html` for GitHub Pages
  - Dependencies: `renv.lock` + `renv/` (use `{renv}`)
  - Bootstrapping/config: `R/___Init_project___.R` and `R/00_Config_file.R`
- The website repo ([SSoQE_website/_quarto.yml](../SSoQE_website/_quarto.yml)) is a Quarto website with `output-dir: docs`.

## Rendering & publishing (Quarto → `docs/`)
- Slides are rendered via an R script that calls `quarto::quarto_render()` and then copies `Presentation/index.html` to `docs/index.html`.
  - Example implementation: [SSoQE-Lecture_template/R/render.R](../SSoQE-Lecture_template/R/render.R)
- Quarto in these repos often uses a `pre-render` hook to run config/theme setup before rendering.
  - Example: [SSoQE-Lecture_template/Presentation/_quarto.yml](../SSoQE-Lecture_template/Presentation/_quarto.yml) (`pre-render: "../R/00_Config_file.R"`)
- When changing slides/exercises, ensure `docs/index.html` stays in sync (that’s what GitHub Pages serves).

## Dependency management (`renv`)
- Prefer `renv::restore()` from `renv.lock` over ad-hoc `install.packages()`.
- First-time setup is typically scripted:
  - Example: [SSoQE-Lecture_template/R/___Init_project___.R](../SSoQE-Lecture_template/R/___Init_project___.R)
- Use `here::here()` for paths (common convention across repos).

## Theme system (don’t hand-edit generated files)
- Several lecture repos auto-generate Quarto + exercise + ggplot theme files from JSON.
  - Config sources live in `Presentation/*.json` (e.g. `colors.json`, `fonts.json`).
  - Generated outputs include `Presentation/_colors.scss`, `Presentation/_fonts.scss`, `R/Exercises/_*.scss`, and `R/set_r_theme.R`.
- If styling changes are needed, edit the JSON inputs and re-render; avoid manual edits to generated `.scss`.

## Repo-specific variations to watch
- Some older repos render from `Presentation/render.R` (instead of `R/render.R`).
  - Example: [SSoQE-Functional_Programming_with_fossil_pollen_data/Presentation/render.R](../SSoQE-Functional_Programming_with_fossil_pollen_data/Presentation/render.R)
- `{targets}` appears inside teaching material (code in slides), not necessarily as a project pipeline.
  - Example occurrences: [SSoQE-Functional_Programming_with_fossil_pollen_data/Presentation/presentation.qmd](../SSoQE-Functional_Programming_with_fossil_pollen_data/Presentation/presentation.qmd)

## When making changes
- Treat each top-level folder as its own repo/project; avoid cross-repo refactors.
- Keep outputs consistent with the existing publishing approach (`docs/` as the deploy artifact).
