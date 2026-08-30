# Core repository rules

## Start with evidence

- Inspect the repository, its local instructions, Git status, and relevant
  entry points before proposing or making changes.
- Treat every top-level SSoQE repository as an independent project and Git
  history. Never assume a workspace folder is a monorepo.
- Confirm existing commands and conventions from repository files. Do not
  invent scripts, targets, branches, labels, or publishing workflows.
- Prefer the public SSoQE website for current public wording. Do not copy
  private planning information into public files.

## Protect other people's work

- Preserve unrelated tracked and untracked changes. Do not clean, reset,
  reformat, stage, or commit them.
- Some repositories are maintained by other teachers. Keep changes inside the
  requested scope and retain intentional repository-specific conventions.
- Before editing an existing instruction file, determine whether it is managed
  by the SSoQE synchronization script or owned by that repository.
- Do not expose private repository names, unpublished course details,
  credentials, personal data, or local absolute paths in public output.

## Make reproducible changes

- Prefer source files over generated artifacts and identify the applicable
  build or rendering command before editing.
- Keep inputs immutable. Write derived data and output to distinct,
  intentionally named objects or files.
- Record randomness with an explicit seed and avoid dependence on a user's
  global environment, working directory, or interactive session history.
- Do not add package installation, dependency restoration, or network download
  to an ordinary analysis or rendering path. Put setup in the repository's
  documented setup workflow.
- Preserve existing file encoding and line endings. New text files must be
  UTF-8 without a byte-order mark.

## Git and review

- Work on the repository's current branch unless the task establishes a
  different branch workflow.
- Review `git status`, the focused diff, and staged content separately.
- Stage or commit only when requested. Never include unrelated changes.
- Validate in proportion to the change: parse first, then focused checks,
  followed by rendering or broader tests when applicable.
- Report what was changed, what was validated, and any checks that could not be
  run. Do not claim success from the presence of an output file alone.
