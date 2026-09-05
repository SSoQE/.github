<div align="center">

<img src="https://ssoqe.github.io/SSoQE_website/photos/SSOQE_logo3.png" width="150" alt="SSoQE logo">

# Science School on Quantitative Ecology

**Organization infrastructure and shared contributor guidance**

[Website](https://ssoqe.github.io/SSoQE_website/) · [2026 programme](https://ssoqe.github.io/SSoQE_website/About/program.html) · [GitHub organization](https://github.com/SSoQE)


| **🏫 Repository information** | **🧰 Technical** | **📌 Status** |
|:---:|:---:|:---:|
| ![SSoQE](https://img.shields.io/badge/SSoQE-2026-155560) | ![Type](https://img.shields.io/badge/Type-Organization_Infrastructure-155560) | ![Status](https://img.shields.io/badge/Status-Active-509A8E) |
| ![Scope](https://img.shields.io/badge/Scope-Organization--wide-C2A337) | ![Topic](https://img.shields.io/badge/Topic-Agent_Guidance-155560) | ![Tools](https://img.shields.io/badge/Tools-Markdown_%7C_R-276DC3) |

</div>

## 🌱 About SSoQE

The Science School on Quantitative Ecology (SSoQE) is an intensive school for Master's and PhD students in ecology and related fields. It has been jointly organized by Charles University in Prague and the University of Bayreuth since 2024 and focuses on quantitative ecology, modern data analysis, reproducible research, and collaboration.

SSoQE 2026 takes place from 14 to 19 September 2026 in Wallenfels, Germany. The public website is the source of truth for the current programme, participant information, and logistical details.

## 🧩 Purpose of this repository

This repository contains two organization-wide resources:

- `profile/README.md` provides the public GitHub organization profile.
- `AGENTS.md` and `.ai/` provide the canonical repository and authoring instructions for AI agents working in SSoQE repositories.

The independent repositories in the SSoQE organization have their own maintainers, histories, dependencies, and publication workflows. They must not be treated as one monorepo.

## 🛠️ Contributor guidance

Read `AGENTS.md` before changing this repository or propagating agent instructions. The standards cover strict Git authorization gates, R coding, reproducibility, Quarto authoring and rendering, SSoQE branding, repository profiles, and generated-file ownership.

For substantial slide work, [presentation authoring](.ai/presentation-authoring.md) describes reference selection, live teaching voice, visual explanations, reveal sequences, practice, and checks before handoff. Its personal style guidance applies to Ondřej Mottl's decks or an explicit request to use his style. The [presentation reviewer](.ai/agents/presentation-reviewer.md) checks both the rendered result and the teaching sequence. Other teachers' styles remain their own.

Validate local canonical changes with:

```powershell
Rscript R/test_agent_instructions.R
```

`R/sync_agent_instructions.R` accepts `--check` or `--write`, one or more `--repository-path` arguments, and a `--canonical-revision` containing the full 40-character commit SHA. Adapters pin their links to that revision. Use a published revision containing the desired modules for an authorized rollout; changing this checkout alone does not update already pinned lesson adapters.

`--write` changes generated adapters in other repositories and must be used only when that cross-repository edit is explicitly authorized. It does not authorize staging, committing, pushing, or opening pull requests.

## 🎨 SSoQE identity

The current SSoQE logo is the [published website asset](https://ssoqe.github.io/SSoQE_website/photos/SSOQE_logo3.png). Preserve its aspect ratio, transparency, padding, and original colors. Shared color and typography tokens are documented in `.ai/branding.md`.

## 📬 Contact

For information about the school, visit the [SSoQE website](https://ssoqe.github.io/SSoQE_website/) and its [team page](https://ssoqe.github.io/SSoQE_website/About/team.html).
