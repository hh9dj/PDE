# hunk-review-plan

Hunk extension for controlling diff file review order and attaching per-file overview notes from an agent or the CLI.

## Behavior

- Changeset ordering: Reorders diff files through `transformChangeset` using the active plan for the current Git repository root.
  - Default mode (`only = false`): Listed files appear first in the plan order; unlisted diff files stay appended at the end.
  - Subset mode (`only = true` / `--only`): Hides diff files that are not in the plan. If a stale `--only` plan matches zero files in the current diff, Hunk falls back to showing all files with a warning toast.
- Bottom notes pane: Registers a toggleable bottom pane (`Review note`) showing the active file's step index (`[N/M]` or `[unlisted]`), plan title, mode indicator, one-line summary, and wrapped multi-line note.
- Status line badge: Displays `plan N/M` (or `plan unlisted/M`, plus `[only]` when filtering) on the right side of the status line whenever a plan is active.
- Live reload: Watches the per-repository plan file (90ms debounce) and triggers `ctx.review.requestReload()` when `hunk plan` updates or clears the plan while Hunk is open.
- Cross-platform normalization: Normalizes Windows backslashes, leading `./` segments, CRLF/CR line endings, UTF-8 BOM from PowerShell stdin, and win32 case-insensitive repository root hashing.

## Storage

Plans are stored as one JSON file per repository root (hashed with SHA-256).

State directory precedence:

1. `HUNK_REVIEW_PLAN_STATE_DIR` environment variable, if set
2. `$XDG_STATE_HOME/hunk/hunk-review-plan`, if `XDG_STATE_HOME` is set
3. `%LOCALAPPDATA%\hunk\hunk-review-plan` on Windows, or `~/.local/state/hunk/hunk-review-plan` on Linux/macOS

## CLI usage

`hunk plan` runs headlessly and exits immediately. It does not open the TUI.

### Set a full plan from JSON

POSIX shells:

```bash
hunk plan set --repo . --stdin --json <<'EOF'
{
  "title": "Auth token expiry",
  "only": false,
  "files": [
    {
      "path": "src/types.ts",
      "summary": "Define expiry fields on SessionToken",
      "note": "Start here because downstream handlers depend on this shape."
    },
    {
      "path": "src/auth.ts",
      "summary": "Reject expired tokens in middleware",
      "note": "Validates expiresAt before loading the user profile.\nCheck the 30s grace window."
    }
  ]
}
EOF
```

PowerShell:

```powershell
@'
{
  "title": "Auth token expiry",
  "only": false,
  "files": [
    {
      "path": "src/types.ts",
      "summary": "Define expiry fields on SessionToken",
      "note": "Start here because downstream handlers depend on this shape."
    }
  ]
}
'@ | hunk plan set --repo . --stdin --json
```

Flags `--title <text>`, `--only`, and `--all` override the matching JSON fields when passed.

### Set file order only

Preserves existing summaries and notes for paths already in the plan:

```bash
hunk plan set --repo . [--only|--all] src/types.ts src/auth.ts tests/auth.test.ts
```

### Add or update a single file note

```bash
hunk plan note --repo . --file src/auth.ts \
  --summary "Validate expiry" \
  --note "Checks token expiry before user lookup." \
  --position 2
```

For multi-line notes, pass `--stdin` instead of `--note`:

```bash
hunk plan note --repo . --file src/auth.ts --summary "Validate expiry" --stdin <<'EOF'
Checks token expiry before user lookup.
Watch out for the 30s clock-skew grace window.
EOF
```

### Inspect or clear the active plan

```bash
hunk plan show --repo . [--json]
hunk plan clear --repo . [--json]
```

## Commands and keybindings

The extension registers three commands (also available from the Extensions menu):

- `hunk-review-plan.toggle-notes` (default: `alt+n`) - toggle the bottom review note pane
- `hunk-review-plan.toggle-only` (default: `alt+o`) - toggle showing only planned files
- `hunk-review-plan.clear-plan` (default: unbound) - clear the active repository plan

### Configuring keybindings (recommended)

Remap or unbind commands in your Hunk user config (`~/.config/hunk/config.toml`) under `[keybindings]`:

```toml
[keybindings]
"hunk-review-plan.toggle-notes" = "alt+n"
"hunk-review-plan.toggle-only" = ["alt+o", "ctrl+o"]
"hunk-review-plan.clear-plan" = false
```

- Pass a single chord string, an array of chords, or `false` (or `[]`) to unbind.
- User `[keybindings]` always take precedence over extension defaults.

### Extension settings

Optional extension settings live under `[extension.hunk-review-plan]` in `config.toml`:

```toml
[extension.hunk-review-plan]
autoOpen = false

[extension.hunk-review-plan.keybindings]
toggleNotes = "alt+n"
toggleOnly = "alt+o"
clearPlan = false
```

- `autoOpen`: When `true`, opens the bottom notes pane automatically on startup if a plan exists and whenever an external `hunk plan` update arrives.
- `[extension.hunk-review-plan.keybindings]`: Overrides the default chords registered by the extension. Accepts `toggleNotes` / `toggle-notes`, `toggleOnly` / `toggle-only`, and `clearPlan` / `clear-plan` (string, array of strings, or `false`/`""`/`[]` to unbind).

## Installation notes

- NixOS and macOS: `common/hunk/default.nix` links this directory into `~/.config/hunk/extensions/hunk-review-plan` and adds its path to `[extensions].paths` in `hunk/config.toml` (required because Hunk's directory scanner skips symlinked extension directories created by Home Manager).
- Windows: `windows/hunk/setup.ps1` copies this directory to `~\.config\hunk\extensions\hunk-review-plan`.
- Manual testing: `hunk --extension ./common/hunk/extensions/hunk-review-plan plan --help`.

## Development

Run the unit tests from this directory:

```bash
bun test
```
