# SSoQE agent instructions

This repository is the public source of truth for AI-agent guidance used by the Science School on Quantitative Ecology (SSoQE).

## Instruction order

1. Follow platform and user instructions.
2. Read this file and the task-relevant modules under `.ai/`.
3. Read `.ai/repository.md` when it exists in the repository being changed.
4. Follow closer directory-level instructions when they add compatible detail.

Repository-specific guidance may add commands, ownership, or format rules. It must not weaken safety, privacy, reproducibility, or SSoQE branding rules.

## Git authorization gates

A request to inspect or plan authorizes read-only work only. A request to fix or implement additionally authorizes local unstaged file edits. None of these requests authorizes changing branches, the index, commit history, remotes, issues, or pull requests.

- At the start of work, inspect `git status --short`, the current branch, and recent history. Treat all existing changes as user-owned unless the task explicitly says otherwise.
- Do not create, switch, rename, or delete a branch or worktree unless the user explicitly requests that branch or worktree action.
- Do not stage or unstage files unless the user explicitly requests staging. An explicit request to commit authorizes staging only the files required for that approved commit.
- Do not commit, amend, cherry-pick, revert, rebase, reset, or merge unless the user explicitly requests the specific history-changing action.
- Do not push, force-push, pull, publish a branch, or change a remote unless the user explicitly requests the specific remote action. Approval to commit does not authorize a push.
- Do not create, edit, close, reopen, label, assign, or merge a pull request or issue unless the user explicitly requests that specific GitHub action. Approval to push does not authorize a pull request, and approval to open a pull request does not authorize merging it.
- Approval never propagates to a later step. Branch approval is not commit approval; commit approval is not push approval; push approval is not pull-request approval; pull-request approval is not merge approval.
- Never commit or push directly to the default branch unless the user explicitly instructs that exact action.
- Before an approved commit, show the intended file set, stage only that set, review the staged diff, and run `git diff --cached --check`. After any approved Git or GitHub action, report the resulting branch, commit, remote, or pull-request state.
- Never discard or rewrite user work with destructive Git commands. If an authorized operation would overlap unrelated changes, stop and ask rather than cleaning the worktree.

## What SSoQE is

SSoQE (Science School on Quantitative Ecology) is a week-long intensive school, running since 2024 and co-organised by Charles University in Prague and the University of Bayreuth. It serves Master's and PhD students in ecology and related fields, with a focus on quantitative ecology, modern data analysis, reproducible research, and R.

The public SSoQE website is the source of truth for public-facing descriptions, the current programme, schedules, and participant information. Do not replace current website wording with assumptions or private planning notes.

## Repository landscape

The SSoQE workspace contains independent course and lecture repositories, mostly using R and Quarto, together with the public Quarto website. Each top-level Git repository has its own history, maintainers, dependencies, and publishing workflow; never treat the workspace as a monorepo.

A template-derived lecture repository commonly contains the following structure, but agents must verify it rather than assume every repository follows it:

- `Presentation/presentation.qmd` is the slide source.
- `R/Exercises/*.qmd` contains exercise handouts when exercises are provided.
- `docs/index.html` is the GitHub Pages publication output.
- `renv.lock` and `renv/` record the R environment when renv is used.
- `R/___Init_project___.R` and `R/00_Config_file.R` commonly handle setup and configuration.

The website is a root Quarto website project that publishes to `docs/`. Website styling and lecture styling share brand tokens but have separate format-specific implementations.

## Common technical contracts

- Lecture slides are commonly rendered through an R wrapper around `quarto::quarto_render()`, which synchronizes the rendered presentation with `docs/index.html`. Use the repository's actual wrapper and confirm every intentionally tracked publication copy is current.
- Quarto projects may use a `pre-render` hook for configuration or theme generation. Inspect the project YAML and invoked R files before changing or bypassing the hook.
- Restore dependencies from `renv.lock` only through the repository's explicit setup workflow. Do not install packages or run `renv::restore()` during ordinary rendering.
- Use `here::here()` or the repository's established project-root helper for paths.
- Template-derived lecture themes are generated from editable JSON sources. Change the JSON inputs and run the generator; never hand-edit generated SCSS or plotting-theme files.
- Older repositories may use different render-script locations or publishing conventions. Preserve their established entry points unless an explicit migration is requested.
- The presence of `{targets}` code in slides or exercises does not prove that the repository itself uses a targets pipeline. Verify actual project infrastructure before invoking pipeline commands.

## Required modules

- Always read [core rules](.ai/core.md).
- For R code or R configuration, read [R style](.ai/r-style.md).
- For Quarto, Markdown, presentations, exercises, or rendered documentation, read [Quarto style](.ai/quarto-style.md).
- For colors, typography, the SSoQE logo, themes, or visual output, read [branding](.ai/branding.md).
- For repository classification and generated files, read [repository profiles](.ai/repository-profiles.md).

## Scope

These standards apply prospectively to files an agent creates or deliberately changes. Do not refactor unrelated teaching material merely to satisfy them. The instructions are technical and do not prescribe pedagogy, lesson stages, or course content.
