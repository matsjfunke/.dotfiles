# Commit Helper

## Goal

Produce a single-line conventional commit message and run it with `git lfg`.

## Output Rules

- Output the commit message exactly once (do NOT repeat it after running the command).
- Conventional commit format: `<type>: <description>`.
- Prefer types: `fix`, `feat`, `refactor`, `docs`, `test`, `chore`.
- Do not include any scope or ticket in the commit title.
- Keep description concise and technical, explicitly stating what was changed.
- Mention key technical implementation details (for example endpoint, env var, module, migration, guard, fallback).
- No trailing period.

## Co-Author

Always append a `Co-authored-by` trailer to the commit message body based on which AI tool is being used:

- **Cursor**: `Co-authored-by: Cursor <cursoragent@cursor.com>`
- **Claude Code**: `Co-authored-by: claude <noreply@anthropic.com>`

Detect the tool from the environment — if running inside Cursor, use the Cursor co-author.

## Quick Workflow

1. Run `git diff && git status` in the terminal to understand what changed.
2. Identify change intent (bug fix, feature, refactor, etc.) and pick the best type.
3. Write one clear commit message line with concrete technical wording.
4. Run `git lfg "<message>" "Co-authored-by: Cursor <cursoragent@cursor.com>"` in the terminal using the Shell tool with `required_permissions: ["full_network"]` — this is required so the push to GitHub succeeds.
5. Output the commit message once, then the `git lfg` command that was run. Nothing else.

## Invocation

When the user runs `/mcm`:

1. Run `git diff && git status` first (always)
2. Infer the message from the diff
3. Run `git lfg "<message>" "Co-authored-by: Cursor <cursoragent@cursor.com>"` (or claude variant) with `required_permissions: ["full_network"]`
4. Output only the commit message.

## Examples

fix: use runtime release tag for settings version across Azure AWS and GCP with build-version fallback

fix: use CHAT_INPUT_MAX_LENGTH for workflow input validation
