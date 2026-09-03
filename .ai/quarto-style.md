# Quarto authoring and rendering

These rules cover Quarto websites, RevealJS lectures, exercise handouts, and mixed repositories containing `.qmd` or `.Rmd` material.

## Edit sources, not products

- Edit `.qmd`, YAML, JSON, SCSS, R generators, and source assets.
- Never hand-edit rendered HTML, generated Markdown, generated theme SCSS/CSS, or copied publication outputs. Use the repository's generator or render wrapper instead.
- Before changing a generated-looking file, locate its source and generation command. If ownership remains unclear, stop and report the ambiguity.

## Source style

- Keep each Markdown paragraph on one physical source line, without hard line breaks in the middle of a sentence or paragraph. Separate paragraphs with one blank line and use consistent two-space YAML indentation. The 80-character R limit applies only inside R code cells, never to prose.
- Use descriptive, unique, lower-case chunk labels with hyphens. Put executable cell options in Quarto `#|` comments rather than scattered legacy syntax.
- Give figures and meaningful images explicit captions and alternative text. Record source, creator, licence, and attribution when reusing external media.
- Prefer native Quarto constructs, Pandoc Markdown, and repository theme classes. Use raw HTML only when Quarto cannot express the required behavior.
- Keep internal links relative and verify fragments, downloads, and external URLs after changing navigation or filenames.

## Execution

- Rendering must work from a clean R session without objects from `.GlobalEnv`, an IDE-only working directory, or manual pre-execution.
- Use project-relative paths and explicit inputs. Do not install packages, restore renv, or silently download mutable remote data while rendering.
- Declare intentional caching and freezing in project configuration. Never mistake a stale cached output for validation of changed source.
- Keep code shown to readers executable unless it is explicitly marked as a non-executed counterexample.

## Repository contracts

- A Quarto website renders from its root project configuration into `docs/`. Use the repository's documented command, normally `quarto render`.
- A template-derived lecture renders `Presentation/presentation.qmd` through the repository wrapper, normally `R/render.R`. Preserve the repository's publication contract between `Presentation/index.html`, `Presentation/presentation.html`, and `docs/index.html`.
- Exercises render through their local Quarto configuration under `R/Exercises/` and retain its output, theme, and `keep-md` conventions.
- Older or mixed repositories keep their established render entry point. Do not impose the current lecture template without an explicit migration task.

## Validation

- Read the full render log and resolve new warnings or explain why they are harmless.
- Check changed output for missing assets, broken links, clipped or overflowing code, unreadable tables, and incorrect syntax highlighting.
- Inspect websites at desktop and narrow widths. Inspect RevealJS slides at the intended viewport and check fragment/animation states, not only final slides.
- Confirm publication copies match the freshly rendered canonical output when the repository intentionally tracks more than one copy.

### Rendered slide composition

Technical overflow checks are not sufficient evidence that a slide is visually successful. When presentation content or layout changes:

- Inspect a whole-deck overview for visual rhythm, repeated imbalance, and unexpectedly flat or crowded sequences, then inspect every slide at a readable full size.
- Judge each slide as a complete canvas. Check vertical balance, title-to-content separation, spacing between elements, edge and footer clearance, dominant-element hierarchy, and whether whitespace is intentional.
- For slides with fragments, inspect the initial state, every materially different intermediate state, and the final state. Prompts must work before answers appear, and revealed content must not hide, displace, or crowd the prompt.
- Judge figures from the rendered slide rather than source dimensions alone. Check internal whitespace, aspect ratio, label size, and whether the plotted content fills its intended region.
- Use automated geometry or overflow measurements only to identify candidates for inspection, never as automatic pass/fail evidence. Final assessment requires visual judgment at the intended viewport.
- After changing spacing, grouping, or figure dimensions, render again and recheck the affected slide and its surrounding sequence. After the final source edit, perform one final render, inspect the whole-deck overview and high-risk slides at full size, and report remaining warnings or validation gaps.

### Independent presentation review

Before describing a new or substantially revised presentation as ready for human review or publication, assign the complete deck to a separate read-only reviewer agent or subagent using the [presentation reviewer](agents/presentation-reviewer.md). This gate applies to new decks, substantial restructuring or visual redesign, changes affecting several slides or fragment sequences, and shared theme changes. It is not required for isolated spelling, metadata, or link corrections unless they alter rendered behaviour.

The authoring agent must provide the reviewer with the complete source, current rendered output, intended viewport, render log, and relevant repository instructions. The reviewer reports findings but never edits the artifact. The authoring agent resolves credible findings, renders again, and obtains a focused recheck of affected slides and surrounding sequences before handoff.

If the environment has no separate reviewer capability, complete every available self-check and report explicitly that independent review was not performed. Never claim that the gate passed when only the authoring agent reviewed the deck; the missing independent pass does not by itself block an isolated low-risk correction.
