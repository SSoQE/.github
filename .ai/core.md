# Core repository rules

## Start with evidence

- Inspect the repository, its local instructions, Git status, and relevant entry points before proposing or making changes.
- Treat every top-level SSoQE repository as an independent project and Git history. Never assume a workspace folder is a monorepo.
- Confirm existing commands and conventions from repository files. Do not invent scripts, targets, branches, labels, or publishing workflows.
- Prefer the public SSoQE website for current public wording. Do not copy private planning information into public files.

## Protect other people's work

- Preserve unrelated tracked and untracked changes. Do not clean, reset, reformat, stage, or commit them.
- Some repositories are maintained by other teachers. Keep changes inside the requested scope and retain intentional repository-specific conventions.
- Before editing an existing instruction file, determine whether it is managed by the SSoQE synchronization script or owned by that repository.
- Do not expose private repository names, unpublished course details, credentials, personal data, or local absolute paths in public output.

## Make reproducible changes

- Prefer source files over generated artifacts and identify the applicable build or rendering command before editing.
- Keep inputs immutable. Write derived data and output to distinct, intentionally named objects or files.
- Record randomness with an explicit seed and avoid dependence on a user's global environment, working directory, or interactive session history.
- Do not add package installation, dependency restoration, or network download to an ordinary analysis or rendering path. Put setup in the repository's documented setup workflow.
- SSoQE repositories are R-first. Do not add Python scripts, Python environments, or Python dependencies unless the user explicitly requests an exception for that repository.
- Preserve existing file encoding and line endings. New text files must be UTF-8 without a byte-order mark.

## Git and review

- Treat inspection, local editing, branch changes, staging, committing, pushing, pull-request operations, and merging as separate authorization gates. Permission for one gate never authorizes the next.
- A request to inspect or plan authorizes read-only work only. A request to fix or implement additionally authorizes local unstaged edits; it does not authorize any Git or GitHub mutation.
- Do not create or switch branches or worktrees without an explicit request. Do not stage files without an explicit staging request, except as the necessary scoped substep of an explicitly requested commit.
- Do not commit or otherwise change history without explicit authorization. A commit request does not authorize pushing.
- Do not push, pull, publish branches, or change remotes without explicit authorization. A push request does not authorize opening or changing a pull request.
- Do not create, edit, close, or merge pull requests or issues without explicit authorization for that action. Opening a pull request does not authorize merging it.
- Never commit or push directly to the default branch unless explicitly instructed. Never force-push, rewrite history, or discard user work without explicit authorization and a verified scope.
- Before an approved commit, inspect the branch and status, identify the exact file set, stage only that set, review the staged diff, and run `git diff --cached --check`.
- Preserve unrelated tracked and untracked changes throughout. If an authorized operation overlaps them, stop and ask instead of cleaning, resetting, stashing, or absorbing them.
- Validate in proportion to the change: parse first, then focused checks, followed by rendering or broader tests when applicable.
- Report what was changed, what was validated, and any checks that could not be run. After an approved Git or GitHub action, report the resulting state precisely.
