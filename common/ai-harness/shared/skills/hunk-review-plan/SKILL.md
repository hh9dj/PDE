---
name: hunk-review-plan
description: Orders diff files for review in Hunk and attaches per-file overview notes shown in a toggleable bottom pane via `hunk plan` CLI commands. Use when preparing a structured diff walkthrough, reordering files for review, filtering a diff to a subset of files, or explaining what each file's changes are about in Hunk (works on Linux, macOS, and Windows).
---

# Hunk Review Plan

Use `hunk plan` (provided by the `hunk-review-plan` extension) to control the order of files in a Hunk diff review and attach a per-file note explaining what each file's change is about.

- `hunk plan` is headless and exits immediately. It does not open the TUI.
- If Hunk is already open on the repository, Hunk reloads automatically and updates the file order and bottom notes pane.
- If Hunk is not open yet, the plan is persisted per repository and applied the next time the user runs `hunk diff`.
- Do not launch `hunk diff` or `hunk show` directly from an agent session.

## When to pair with `hunk-review`

- Use `hunk-review-plan` (`hunk plan ...`) for file-level reading order, optional subset scoping (`--only`), and per-file change explanations shown in the bottom pane (`alt+n`).
- Use `hunk-review` (`hunk session ...`) for line-level inline comments, range highlights, and live viewport navigation.

## Workflow

1. Inspect the changed files first:
   - If a Hunk session is running: `hunk session review --repo . --json`
   - Otherwise: `git diff --name-only` (or `git diff main...HEAD --name-only` for a branch diff)
2. Read the diffs or files as needed to understand each file's role in the change.
3. Choose a clear reading order (for example: schema/types -> core implementation -> callers/wiring -> configuration -> tests/docs).
4. Write a concise `summary` (one line) and `note` (short explanation of intent, key changes, and review focus) for each file.
5. Apply the full plan in one atomic `hunk plan set --repo . --stdin` call.
6. Tell the user the order is applied and remind them that `alt+n` toggles the bottom notes pane (`alt+o` toggles `--only` mode).

## JSON schema (`hunk plan set --stdin`)

```json
{
  "title": "Optional short title for the review",
  "only": false,
  "files": [
    {
      "path": "src/types.ts",
      "summary": "Define the new session token fields",
      "note": "Adds expiresAt and refreshScope to SessionToken. Start here because all downstream handlers depend on this shape."
    },
    {
      "path": "src/auth.ts",
      "summary": "Enforce token expiry during request validation",
      "note": "Rejects expired tokens with HTTP 401 and logs clock-skew warnings.\nCheck the 30s grace window on line 84."
    }
  ]
}
```

- `files[].path`: Repository-relative path (forward slashes preferred; Windows backslashes and leading `./` are normalized automatically).
- `only`: Optional boolean (default `false`).
  - `false`: Listed files appear first in the specified order; unlisted diff files remain appended at the end.
  - `true`: Hides diff files that are not listed in `files`. If a stale `--only` plan matches zero files in the current diff, Hunk falls back to showing all files with a warning.
- `files[].summary`: Optional single-line headline highlighted in the pane.
- `files[].note`: Optional multi-line explanation displayed in the bottom pane.

## Setting a full plan (cross-platform)

POSIX shells (bash, zsh on Linux and macOS):

```bash
hunk plan set --repo . --stdin --json <<'EOF'
{
  "title": "Auth token expiry",
  "only": false,
  "files": [
    {
      "path": "src/types.ts",
      "summary": "Define expiry fields on SessionToken",
      "note": "Start here to see the updated token contract."
    },
    {
      "path": "src/auth.ts",
      "summary": "Reject expired tokens in middleware",
      "note": "Validates expiresAt before loading the user profile."
    }
  ]
}
EOF
```

Windows PowerShell (`pwsh`, Gemini CLI on Windows):

```powershell
@'
{
  "title": "Auth token expiry",
  "only": false,
  "files": [
    {
      "path": "src/types.ts",
      "summary": "Define expiry fields on SessionToken",
      "note": "Start here to see the updated token contract."
    },
    {
      "path": "src/auth.ts",
      "summary": "Reject expired tokens in middleware",
      "note": "Validates expiresAt before loading the user profile."
    }
  ]
}
'@ | hunk plan set --repo . --stdin --json
```

## CLI reference

### Set order and notes from JSON

```bash
hunk plan set [--repo <path>] [--title <text>] [--only|--all] --stdin [--json]
```

Flags `--only`, `--all`, and `--title` override the corresponding JSON fields when provided.

### Set file order only (preserves existing notes)

```bash
hunk plan set [--repo <path>] [--only|--all] [--json] src/types.ts src/auth.ts tests/auth.test.ts
```

### Add or update one file's note

```bash
hunk plan note [--repo <path>] --file <path> --summary "<headline>" --note "<explanation>" [--position <1-based>] [--json]
```

For multi-line notes, pipe the note body via `--stdin` instead of `--note`:

```bash
hunk plan note --repo . --file src/auth.ts --summary "Validate expiry" --stdin <<'EOF'
Checks token expiry before user lookup.
Watch out for the 30s clock-skew grace window.
EOF
```

### Inspect the active plan

```bash
hunk plan show [--repo <path>] [--json]
```

### Clear the active plan

```bash
hunk plan clear [--repo <path>] [--json]
```

## User controls inside Hunk

- `alt+n` (`hunk-review-plan.toggle-notes`): Toggle the bottom notes pane.
- `alt+o` (`hunk-review-plan.toggle-only`): Toggle hiding unlisted files while a plan is active.
- Extensions menu -> Clear review plan (`hunk-review-plan.clear-plan`): Clear the repository plan from inside Hunk.

## Writing good per-file notes

- Explain why the file changed and how it connects to the previous or next file in the review order.
- Call out subtle logic, edge cases, or assumptions worth checking.
- Keep notes concise so they read cleanly in the bottom pane without excessive scrolling.
- Prefer one `hunk plan set --stdin` call over many separate `hunk plan note` invocations so Hunk reloads once.
