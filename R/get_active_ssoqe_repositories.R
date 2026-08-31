#!/usr/bin/env Rscript

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

get_active_ssoqe_repositories <- function(
  organization = "SSoQE",
  include_archived = FALSE
) {
  query <- paste0(
    ".[] | [.name, .isPrivate, .isArchived, ",
    ".defaultBranchRef.name, .url, .sshUrl] | @tsv"
  )
  output <- run_command(
    command = "gh",
    arguments = c(
      "repo",
      "list",
      organization,
      "--limit",
      "500",
      "--json",
      paste0(
        "name,isArchived,isPrivate,defaultBranchRef,",
        "url,sshUrl"
      ),
      "--jq",
      shQuote(query)
    )
  )

  if (length(output) == 0L) {
    return(
      data.frame(
        name = character(),
        isPrivate = logical(),
        isArchived = logical(),
        defaultBranchRef = character(),
        url = character(),
        sshUrl = character(),
        check.names = FALSE
      )
    )
  }

  repositories <- utils::read.delim(
    text = paste(output, collapse = "\n"),
    header = FALSE,
    sep = "\t",
    quote = "",
    col.names = c(
      "name",
      "isPrivate",
      "isArchived",
      "defaultBranchRef",
      "url",
      "sshUrl"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  repositories$isPrivate <- tolower(repositories$isPrivate) == "true"
  repositories$isArchived <- tolower(repositories$isArchived) == "true"

  if (!include_archived) {
    repositories <- repositories[!repositories$isArchived, , drop = FALSE]
  }

  repositories[order(repositories$name), , drop = FALSE]
}

parse_arguments <- function(arguments) {
  result <- list(
    organization = "SSoQE",
    include_archived = FALSE
  )
  index <- 1L
  while (index <= length(arguments)) {
    argument <- arguments[[index]]
    if (identical(argument, "--include-archived")) {
      result$include_archived <- TRUE
      index <- index + 1L
      next
    }
    if (identical(argument, "--organization")) {
      if (index == length(arguments)) {
        stop("--organization requires a value", call. = FALSE)
      }
      result$organization <- arguments[[index + 1L]]
      index <- index + 2L
      next
    }
    stop("Unknown argument: ", argument, call. = FALSE)
  }

  result
}

main <- function() {
  arguments <- parse_arguments(commandArgs(trailingOnly = TRUE))
  repositories <- get_active_ssoqe_repositories(
    organization = arguments$organization,
    include_archived = arguments$include_archived
  )
  utils::write.table(
    repositories,
    file = stdout(),
    sep = "\t",
    quote = FALSE,
    row.names = FALSE,
    na = ""
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
