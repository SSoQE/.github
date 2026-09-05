#!/usr/bin/env Rscript

managed_marker <- "SSOQE-GENERATED-AGENT-ADAPTER"
valid_profiles <- c(
  "auto",
  "quarto-website",
  "template-lecture",
  "mixed-legacy-r",
  "content-binary"
)

read_text <- function(path) {
  size <- file.info(path)$size
  if (is.na(size) || size == 0L) {
    return("")
  }
  connection <- file(path, open = "rb")
  on.exit(close(connection), add = TRUE)
  rawToChar(readBin(connection, what = "raw", n = size))
}

write_text <- function(path, text) {
  directory <- dirname(path)
  if (!dir.exists(directory)) {
    dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  }
  connection <- file(path, open = "wb")
  on.exit(close(connection), add = TRUE)
  writeBin(charToRaw(enc2utf8(text)), connection)
}

normalize_text <- function(text) {
  text <- gsub("\r\n?", "\n", text)
  text <- sub("[[:space:]]+$", "", text)
  paste0(text, "\n")
}

run_command <- function(command, arguments) {
  error_file <- tempfile("ssoqe-command-error-")
  on.exit(unlink(error_file), add = TRUE)
  output <- suppressWarnings(
    system2(
      command = command,
      args = arguments,
      stdout = TRUE,
      stderr = error_file
    )
  )
  status <- attr(output, "status")
  if (is.null(status)) {
    status <- 0L
  }
  if (status != 0L) {
    details <- readLines(error_file, warn = FALSE)
    stop(
      paste(c("Command failed:", details), collapse = "\n"),
      call. = FALSE
    )
  }
  output
}

get_repository_profile <- function(root) {
  quarto_config <- file.path(root, "_quarto.yml")
  if (file.exists(quarto_config)) {
    config <- readLines(quarto_config, warn = FALSE)
    website_pattern <- paste0(
      "^\\s*type:\\s*['\"]?website['\"]?\\s*$"
    )
    if (any(grepl(website_pattern, config, perl = TRUE))) {
      return("quarto-website")
    }
  }

  presentation <- file.path(root, "Presentation", "presentation.qmd")
  render_wrapper <- file.path(root, "R", "render.R")
  if (file.exists(presentation) && file.exists(render_wrapper)) {
    return("template-lecture")
  }

  tracked_files <- run_command(
    command = "git",
    arguments = c("-C", shQuote(root), "ls-files")
  )
  source_pattern <- "\\.(R|r|Rmd|rmd|qmd)$"
  if (any(grepl(source_pattern, tracked_files, perl = TRUE))) {
    return("mixed-legacy-r")
  }

  "content-binary"
}

paragraph <- function(...) {
  paste0(...)
}

bullet <- function(...) {
  paste0("- ", paragraph(...))
}

get_profile_guidance <- function(repository_profile) {
  switch(
    repository_profile,
    "quarto-website" = bullet(
      "Render from the root Quarto website project into its configured ",
      "`docs/` directory. Edit source pages and source SCSS, never ",
      "rendered site files."
    ),
    "template-lecture" = bullet(
      "Render the presentation through the repository wrapper, normally ",
      "`R/render.R`. Edit theme JSON and run `R/generate_theme.R`; do not ",
      "hand-edit generated theme or publication files."
    ),
    "mixed-legacy-r" = bullet(
      "Preserve the repository's established R/Quarto entry points. Do not ",
      "migrate it to the current lecture template without an explicit ",
      "migration task."
    ),
    "content-binary" = bullet(
      "Preserve source and binary ownership. Do not convert or hand-edit ",
      "generated office, image, PDF, or site artifacts without an explicit ",
      "workflow."
    ),
    stop(
      "Unsupported repository profile: ",
      repository_profile,
      call. = FALSE
    )
  )
}

get_adapter_markdown <- function(
  repository_profile,
  canonical_revision,
  canonical_repository
) {
  revision <- tolower(canonical_revision)
  canonical_base <- paste0(
    canonical_repository,
    "/blob/",
    revision
  )
  profile_guidance <- get_profile_guidance(repository_profile)

  lines <- c(
    paste0("<!-- ", managed_marker, "; DO NOT EDIT BY HAND -->"),
    "# SSoQE repository instructions",
    "",
    paste0(
      "Canonical revision: [",
      revision,
      "](",
      canonical_repository,
      "/tree/",
      revision,
      ")"
    ),
    "",
    paste0("Repository profile: `", repository_profile, "`"),
    "",
    paragraph(
      "Before substantive work, read the canonical [router](",
      canonical_base,
      "/AGENTS.md) and its task-relevant [core](",
      canonical_base,
      "/.ai/core.md), [R](",
      canonical_base,
      "/.ai/r-style.md), [Quarto](",
      canonical_base,
      "/.ai/quarto-style.md), [presentation authoring](",
      canonical_base,
      "/.ai/presentation-authoring.md), [branding](",
      canonical_base,
      "/.ai/branding.md), and [profile](",
      canonical_base,
      "/.ai/repository-profiles.md) modules. Also read the local ",
      "`.ai/repository.md` when present. Local guidance may add compatible ",
      "rules but may not weaken canonical safety, privacy, reproducibility, ",
      "or branding."
    ),
    "",
    "## Mandatory baseline",
    "",
    bullet(
      "Treat this as an independent repository. Inspect its instructions, ",
      "Git status, and established commands before editing."
    ),
    bullet(
      "Treat implementation as authorization for local unstaged edits only. ",
      "Never create or switch branches, stage, commit, push, open or edit a ",
      "pull request, or merge without explicit authorization for that ",
      "specific action. Permission for one action never authorizes the next."
    ),
    bullet(
      "Preserve all unrelated tracked and untracked work. Do not disclose ",
      "private repository names, unpublished information, personal data, or ",
      "credentials."
    ),
    bullet(
      "Apply standards prospectively; do not clean up unrelated teaching ",
      "material."
    ),
    bullet(
      "For R, prefer tidyverse clarity, native `|>`, explicit namespaces, ",
      "`snake_case`, immutable raw inputs, `here::here()`, explicit seeds, ",
      "one reusable function per file, roxygen documentation, and focused ",
      "tests. Store every `.R` file under `R/` or a suitable subdirectory of ",
      "`R/`; never under `scripts/`. Keep R source lines at or below 80 ",
      "characters where practical, ",
      "including R code inside Quarto or R Markdown cells. The limit does not ",
      "apply to Markdown prose, YAML, or prose paragraphs in `.qmd` files."
    ),
    bullet(
      "Do not install packages or restore dependencies during normal ",
      "analysis or rendering. Do not rely on interactive state."
    ),
    bullet(
      "SSoQE repositories are R-first. Do not add Python scripts, Python ",
      "environments, or Python dependencies unless the user explicitly ",
      "requests an exception for that repository."
    ),
    bullet(
      "For Quarto, keep each Markdown paragraph on one physical source line, ",
      "edit source, and use the repository render command. Never hand-edit ",
      "generated HTML, Markdown, theme files, or copied publication output."
    ),
    bullet(
      "SSoQE colors are `#F2F4F2`, `#1F2937`, `#155560`, `#509A8E`, ",
      "`#A1C3B3`, and `#C2A337`; fonts are Plus Jakarta Sans, Space Grotesk, ",
      "and JetBrains Mono. `SSOQE_logo3` is the current SSoQE logo used by ",
      "the website and lecture materials. Preserve its proportions, colors, ",
      "and accessible contrast."
    ),
    bullet(
      "For substantial slide authoring or review, read the presentation ",
      "authoring module and establish the author. Apply personal style ",
      "guidance only to Ond\u0159ej Mottl's decks or when explicitly ",
      "requested. Keep technical fixes within scope; do not invent universal ",
      "pedagogical requirements or lesson-stage workflows."
    ),
    "",
    "## Profile-specific rule",
    "",
    profile_guidance
  )

  normalize_text(paste(lines, collapse = "\n"))
}

get_adapter_files <- function(
  repository_profile,
  canonical_revision,
  canonical_repository
) {
  markdown <- get_adapter_markdown(
    repository_profile = repository_profile,
    canonical_revision = canonical_revision,
    canonical_repository = canonical_repository
  )
  cursor <- normalize_text(
    paste0(
      "---\n",
      "description: SSoQE repository and authoring instructions\n",
      "alwaysApply: true\n",
      "---\n\n",
      markdown
    )
  )

  list(
    "AGENTS.md" = markdown,
    ".github/copilot-instructions.md" = markdown,
    "CLAUDE.md" = markdown,
    "GEMINI.md" = markdown,
    ".cursor/rules/ssoqe-agent-instructions.mdc" = cursor
  )
}

is_managed_file <- function(path) {
  !file.exists(path) || grepl(
    managed_marker,
    read_text(path),
    fixed = TRUE
  )
}

sync_agent_instructions <- function(
  repository_paths,
  canonical_revision,
  mode,
  profile = "auto",
  canonical_repository = "https://github.com/SSoQE/.github"
) {
  if (!mode %in% c("check", "write")) {
    stop("mode must be check or write", call. = FALSE)
  }
  if (!profile %in% valid_profiles) {
    stop("Unsupported profile: ", profile, call. = FALSE)
  }
  if (!grepl("^[0-9a-fA-F]{40}$", canonical_revision)) {
    stop("Canonical revision must be a 40-character SHA", call. = FALSE)
  }

  problems <- character()
  for (repository in repository_paths) {
    root <- normalizePath(repository, winslash = "/", mustWork = TRUE)
    if (!file.exists(file.path(root, ".git"))) {
      stop("Not a Git repository: ", root, call. = FALSE)
    }

    is_canonical <- file.exists(file.path(root, ".ai", "core.md")) &&
      file.exists(
        file.path(root, "R", "sync_agent_instructions.R")
      )
    if (is_canonical) {
      cat("canonical\tcanonical-source\t", root, "\n", sep = "")
      next
    }

    repository_profile <- if (identical(profile, "auto")) {
      get_repository_profile(root)
    } else {
      profile
    }
    files <- get_adapter_files(
      repository_profile = repository_profile,
      canonical_revision = canonical_revision,
      canonical_repository = canonical_repository
    )

    for (relative_path in names(files)) {
      path <- file.path(root, relative_path)
      expected <- files[[relative_path]]
      if (!is_managed_file(path)) {
        problems <- c(
          problems,
          paste0(root, ": refusing to overwrite unmanaged ", relative_path)
        )
        next
      }

      matches <- file.exists(path) && identical(
        normalize_text(read_text(path)),
        expected
      )
      if (identical(mode, "check")) {
        if (!matches) {
          problems <- c(
            problems,
            paste0(root, ": adapter drift in ", relative_path)
          )
        }
        next
      }

      if (!matches) {
        write_text(path, expected)
        cat("updated\t", repository_profile, "\t", path, "\n", sep = "")
      } else {
        cat("current\t", repository_profile, "\t", path, "\n", sep = "")
      }
    }
  }

  if (length(problems) > 0L) {
    stop(paste(problems, collapse = "\n"), call. = FALSE)
  }
  invisible(TRUE)
}

parse_arguments <- function(arguments) {
  result <- list(
    mode = NULL,
    repository_paths = character(),
    canonical_revision = NULL,
    profile = "auto",
    canonical_repository = "https://github.com/SSoQE/.github"
  )
  index <- 1L
  value_flags <- c(
    "--repository-path",
    "--canonical-revision",
    "--profile",
    "--canonical-repository"
  )

  while (index <= length(arguments)) {
    argument <- arguments[[index]]
    if (argument %in% c("--check", "--write")) {
      requested_mode <- sub("^--", "", argument)
      if (!is.null(result$mode) && result$mode != requested_mode) {
        stop("Use exactly one of --check or --write", call. = FALSE)
      }
      result$mode <- requested_mode
      index <- index + 1L
      next
    }
    if (argument %in% value_flags) {
      if (index == length(arguments)) {
        stop(argument, " requires a value", call. = FALSE)
      }
      value <- arguments[[index + 1L]]
      key <- sub("^--", "", argument)
      key <- gsub("-", "_", key)
      if (identical(key, "repository_path")) {
        result$repository_paths <- c(result$repository_paths, value)
      } else {
        result[[key]] <- value
      }
      index <- index + 2L
      next
    }
    stop("Unknown argument: ", argument, call. = FALSE)
  }

  if (is.null(result$mode)) {
    stop("Use exactly one of --check or --write", call. = FALSE)
  }
  if (length(result$repository_paths) == 0L) {
    stop("At least one --repository-path is required", call. = FALSE)
  }
  if (is.null(result$canonical_revision)) {
    stop("--canonical-revision is required", call. = FALSE)
  }

  result
}

main <- function() {
  arguments <- parse_arguments(commandArgs(trailingOnly = TRUE))
  sync_agent_instructions(
    repository_paths = arguments$repository_paths,
    canonical_revision = arguments$canonical_revision,
    mode = arguments$mode,
    profile = arguments$profile,
    canonical_repository = arguments$canonical_repository
  )
}

if (sys.nframe() == 0L) {
  tryCatch(
    main(),
    error = function(error) {
      message("Error: ", conditionMessage(error))
      quit(status = 1L)
    }
  )
}
