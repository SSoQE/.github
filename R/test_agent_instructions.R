#!/usr/bin/env Rscript

get_script_directory <- function() {
  file_argument <- grep(
    "^--file=",
    commandArgs(trailingOnly = FALSE),
    value = TRUE
  )
  if (length(file_argument) == 0L) {
    stop("Cannot determine the script directory", call. = FALSE)
  }
  script_path <- sub("^--file=", "", file_argument[[1L]])
  dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE))
}

read_text <- function(path) {
  size <- file.info(path)$size
  if (is.na(size) || size == 0L) {
    return("")
  }
  connection <- file(path, open = "rb")
  on.exit(close(connection), add = TRUE)
  rawToChar(readBin(connection, what = "raw", n = size))
}

add_failure <- function(failures, message) {
  c(failures, message)
}

check_encoding <- function(path, failures) {
  size <- file.info(path)$size
  connection <- file(path, open = "rb")
  on.exit(close(connection), add = TRUE)
  bytes <- readBin(connection, what = "raw", n = size)

  if (
    length(bytes) >= 3L &&
      identical(as.integer(bytes[1:3]), c(239L, 187L, 191L))
  ) {
    failures <- add_failure(failures, paste("UTF-8 BOM found:", path))
  }
  text <- rawToChar(bytes)
  valid_text <- iconv(text, from = "UTF-8", to = "UTF-8", sub = NA)
  if (is.na(valid_text)) {
    failures <- add_failure(
      failures,
      paste("Invalid UTF-8 found:", path)
    )
  }
  if (grepl("\uFFFD", text, fixed = TRUE)) {
    failures <- add_failure(
      failures,
      paste("Unicode replacement character found:", path)
    )
  }

  failures
}

check_markdown_links <- function(path, failures) {
  text <- read_text(path)
  locations <- gregexpr(
    "\\[[^]]+\\]\\([^)]+\\)",
    text,
    perl = TRUE
  )
  links <- regmatches(text, locations)[[1L]]
  if (identical(links, character())) {
    return(failures)
  }

  for (link in links) {
    target <- sub("^.*\\(([^)]+)\\)$", "\\1", link, perl = TRUE)
    if (grepl("^(https?://|#|mailto:)", target, perl = TRUE)) {
      next
    }
    target_path <- strsplit(target, "#", fixed = TRUE)[[1L]][[1L]]
    resolved <- file.path(dirname(path), target_path)
    if (!file.exists(resolved)) {
      failures <- add_failure(
        failures,
        paste0("Broken local Markdown link in ", path, ": ", target)
      )
    }
  }

  failures
}

is_markdown_block_line <- function(line) {
  grepl(
    "^(#|<!--|\\s*[-*+]\\s|\\s*[0-9]+\\.\\s|\\|)",
    line,
    perl = TRUE
  )
}

check_markdown_wrapping <- function(path, failures) {
  lines <- strsplit(
    gsub("\r\n?", "\n", read_text(path)),
    "\n",
    fixed = TRUE
  )[[1L]]
  frontmatter <- integer()
  if (length(lines) > 1L && identical(lines[[1L]], "---")) {
    closing <- which(lines[-1L] == "---")
    if (length(closing) > 0L) {
      frontmatter <- seq_len(closing[[1L]] + 1L)
    }
  }

  for (index in seq.int(2L, length(lines))) {
    if (index %in% frontmatter) {
      next
    }
    previous <- lines[[index - 1L]]
    current <- lines[[index]]
    previous_plain <- nzchar(previous) &&
      !is_markdown_block_line(previous)
    current_plain <- nzchar(current) &&
      !is_markdown_block_line(current)
    if (previous_plain && current_plain) {
      failures <- add_failure(
        failures,
        paste0(
          "Possible hard-wrapped paragraph in ",
          path,
          " at line ",
          index
        )
      )
    }
    if (grepl("^\\s{2,}\\S", current, perl = TRUE)) {
      failures <- add_failure(
        failures,
        paste0(
          "Indented Markdown continuation in ",
          path,
          " at line ",
          index
        )
      )
    }
  }

  failures
}

check_r_parse <- function(path, failures) {
  error <- tryCatch(
    {
      parse(file = path, keep.source = TRUE)
      NULL
    },
    error = identity
  )
  if (!is.null(error)) {
    failures <- add_failure(
      failures,
      paste0("R parse error in ", path, ": ", conditionMessage(error))
    )
  }

  failures
}

check_r_line_length <- function(path, failures) {
  lines <- readLines(path, warn = FALSE)
  long_lines <- which(nchar(lines, type = "width") > 80L)
  for (line in long_lines) {
    failures <- add_failure(
      failures,
      paste0("R line exceeds 80 characters in ", path, ":", line)
    )
  }
  failures
}

contains_json_value <- function(text, name, value) {
  expected <- paste0('"', name, '": "', value, '"')
  grepl(expected, text, fixed = TRUE)
}

find_lecture_template <- function(workspace_root) {
  candidates <- list.dirs(
    workspace_root,
    full.names = TRUE,
    recursive = FALSE
  )
  matches <- vapply(
    candidates,
    function(candidate) {
      file.exists(
        file.path(candidate, "Presentation", "colors.json")
      ) &&
        file.exists(
          file.path(candidate, "Presentation", "fonts.json")
        ) &&
        file.exists(file.path(candidate, "R", "generate_theme.R"))
    },
    logical(1L)
  )
  candidates[matches][1L]
}

find_website_style <- function(workspace_root) {
  candidates <- list.dirs(
    workspace_root,
    full.names = TRUE,
    recursive = FALSE
  )
  for (candidate in candidates) {
    config_path <- file.path(candidate, "_quarto.yml")
    style_path <- file.path(candidate, "styles.scss")
    if (!file.exists(config_path) || !file.exists(style_path)) {
      next
    }
    config <- readLines(config_path, warn = FALSE)
    if (any(grepl("^\\s*type:\\s*website\\s*$", config))) {
      return(style_path)
    }
  }
  NA_character_
}

test_agent_instructions <- function(
  canonical_root,
  workspace_root,
  check_private_names = FALSE
) {
  required_files <- c(
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
    "R/sync_agent_instructions.R",
    "R/get_active_ssoqe_repositories.R",
    "R/test_agent_instructions.R"
  )
  paths <- file.path(canonical_root, required_files)
  failures <- character()
  missing <- required_files[!file.exists(paths)]
  for (path in missing) {
    failures <- add_failure(
      failures,
      paste("Missing required file:", path)
    )
  }
  paths <- paths[file.exists(paths)]

  for (path in paths) {
    failures <- check_encoding(path, failures)
  }

  markdown_paths <- paths[grepl("\\.(md|mdc)$", paths)]
  for (path in markdown_paths) {
    failures <- check_markdown_links(path, failures)
    failures <- check_markdown_wrapping(path, failures)
  }

  r_paths <- paths[grepl("\\.R$", paths)]
  for (path in r_paths) {
    failures <- check_r_parse(path, failures)
    failures <- check_r_line_length(path, failures)
  }

  expected_colors <- c(
    white = "#F2F4F2",
    black = "#1F2937",
    midnightGreen = "#155560",
    persianGreen = "#509A8E",
    cambridgeBlue = "#A1C3B3",
    satinSheenGold = "#C2A337"
  )
  expected_fonts <- c(
    body = "Plus Jakarta Sans",
    heading = "Space Grotesk",
    monospace = "JetBrains Mono"
  )

  template_root <- find_lecture_template(workspace_root)
  if (!is.na(template_root)) {
    color_text <- read_text(
      file.path(template_root, "Presentation", "colors.json")
    )
    font_text <- read_text(
      file.path(template_root, "Presentation", "fonts.json")
    )
    for (name in names(expected_colors)) {
      if (!contains_json_value(
        color_text,
        name,
        expected_colors[[name]]
      )) {
        failures <- add_failure(
          failures,
          paste("Lecture color drift:", name)
        )
      }
    }
    for (name in names(expected_fonts)) {
      if (!contains_json_value(
        font_text,
        name,
        expected_fonts[[name]]
      )) {
        failures <- add_failure(
          failures,
          paste("Lecture font drift:", name)
        )
      }
    }
  } else {
    warning("Lecture template not present; skipped JSON brand check")
  }

  website_style <- find_website_style(workspace_root)
  if (!is.na(website_style)) {
    scss <- read_text(website_style)
    for (value in c(expected_colors, expected_fonts)) {
      if (!grepl(value, scss, fixed = TRUE)) {
        failures <- add_failure(
          failures,
          paste("Website branding token missing:", value)
        )
      }
    }
  } else {
    warning("Website checkout not present; skipped SCSS brand check")
  }

  if (check_private_names) {
    script_directory <- file.path(canonical_root, "R")
    source(
      file.path(script_directory, "get_active_ssoqe_repositories.R"),
      local = environment()
    )
    repositories <- get_active_ssoqe_repositories()
    private_names <- repositories$name[repositories$isPrivate]
    public_text <- paste(
      vapply(paths, read_text, character(1L)),
      collapse = "\n"
    )
    if (any(vapply(
      private_names,
      grepl,
      logical(1L),
      x = public_text,
      fixed = TRUE
    ))) {
      failures <- add_failure(
        failures,
        "Private repository name found in canonical files"
      )
    }
  }

  if (length(failures) > 0L) {
    stop(paste(failures, collapse = "\n"), call. = FALSE)
  }
  message("SSoQE agent-instruction validation passed.")
  invisible(TRUE)
}

parse_arguments <- function(
  arguments,
  script_directory
) {
  result <- list(
    canonical_root = dirname(script_directory),
    workspace_root = dirname(dirname(script_directory)),
    check_private_names = FALSE
  )
  index <- 1L
  while (index <= length(arguments)) {
    argument <- arguments[[index]]
    if (identical(argument, "--check-private-names")) {
      result$check_private_names <- TRUE
      index <- index + 1L
      next
    }
    if (argument %in% c("--canonical-root", "--workspace-root")) {
      if (index == length(arguments)) {
        stop(argument, " requires a value", call. = FALSE)
      }
      key <- gsub("-", "_", sub("^--", "", argument))
      result[[key]] <- arguments[[index + 1L]]
      index <- index + 2L
      next
    }
    stop("Unknown argument: ", argument, call. = FALSE)
  }

  result
}

main <- function() {
  script_directory <- get_script_directory()
  arguments <- parse_arguments(
    commandArgs(trailingOnly = TRUE),
    script_directory
  )
  test_agent_instructions(
    canonical_root = arguments$canonical_root,
    workspace_root = arguments$workspace_root,
    check_private_names = arguments$check_private_names
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
