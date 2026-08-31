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
