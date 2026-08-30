# R coding and reproducibility

These rules apply to new or deliberately modified R code. Existing teaching
examples are not a mandate for unrelated cleanup.

## Style

- Prefer tidyverse conventions where they improve clarity and use the native
  pipe `|>` in new code.
- Use explicit package namespaces such as `dplyr::filter()` in reusable code,
  scripts, and teaching documents. Attach packages only where the repository
  deliberately uses that pattern for an interactive teaching sequence.
- Use descriptive `snake_case` names for objects, arguments, functions, and
  files. Name booleans so `TRUE` reads naturally.
- Keep lines at or below 80 characters where practical. Break long calls by
  argument and use trailing commas in multi-line calls when supported.
- Prefer explicit, readable transformations over dense nesting or clever
  metaprogramming.

## Functions and structure

- Put reusable functions in the repository's function directory, normally
  `R/functions/`, with one primary function per file.
- Analytical scripts and Quarto documents should orchestrate functions rather
  than define a growing collection of reusable helpers inline.
- Give functions explicit arguments and a stable return contract. Avoid hidden
  reads from or writes to the global environment.
- Document reusable functions with roxygen2, including purpose, parameters,
  return value, and important side effects or assumptions.
- Add focused tests for reusable logic and edge cases. Tests must not depend on
  execution order or undeclared local files.

## Data and paths

- Never overwrite raw inputs. Use new names for cleaned, filtered, summarized,
  or modelled objects.
- Use `here::here()` or an established project-root helper for project files.
  Do not use `setwd()`, user-specific absolute paths, or repeated `../` chains.
- Separate acquisition, cleaning, analysis, and presentation when the workflow
  is substantial enough to benefit from those boundaries.
- Validate expected columns, types, units, missingness, and join cardinality at
  the boundary where data enter a reusable workflow.

## Dependencies and randomness

- Treat `renv.lock` as the dependency record when the repository uses renv.
  Restore or snapshot only through an explicit setup or maintenance task.
- Do not call `install.packages()` or `renv::restore()` during normal rendering
  or analysis execution.
- Set and document seeds at the narrowest useful scope. Parallel randomness
  must use a reproducible RNG strategy.
