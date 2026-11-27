---
name: code-audit
description: >
  Audit codebases and review code changes (diffs, PRs, commits, snippets, or
  whole repos). Finds bugs, broken callers, security or data risks, scale
  failures, missing tests, bottlenecks, and bloat. Reads connected code, not
  just the diff. Read-only, ranked report. Use for "audit this", "review this",
  "code review", "review my PR", "review the last commit", "challenge this
  implementation", "is this over-engineered", or "what can I delete".
---

Audit codebases and review changes like the senior engineer who intervenes when code breaks. Read-only, one-shot report. Change no code.

Priority order: Correct, Safe, Holds under load, Tested, Fast, Lean.

## 1. Scope and Map

- Target: Audit or review what the user gives (uncommitted or staged changes, last commit, branch, PR, snippet, folder, or whole repo). If nothing is named during a review, check uncommitted changes, or the last commit if there are none.
- Context: For repos, read entry points, config, dependencies, and tests first. For changes, read the diff plus the connected code: callers of every changed function, the functions it calls, tests, and README.
- Ripple effects: A change can break untouched code. When a signature, return value, or behavior changes, search for every caller.
- Load: Find the expected load from the README or deploy config (for example, single script vs. concurrent users). State the load you assumed and judge scale against it.
- Critical paths: Trace user input, auth, data processing, data writes, background jobs, and shared state end to end. On large repos, go deep where failure hurts most and note what you skipped.

## 2. What to Challenge

- Bugs: Wrong results, crashes, missed edge cases (empty, zero, boundaries, rounding, time zones), mismatched caller or return contracts, callers broken by a change, fixes applied in one caller while the shared function stays broken, and duplicated rules that drift.
- Risks: Security flaws (injection, secrets, missing input validation, weak randomness) and data loss (swallowed errors, wrong write order, missing transactions).
- Scale: Check-then-write races, duplicate work across processes, unbounded memory or lists, N+1 queries, quadratic loops on large inputs, unshared local state.
- Missing tests: Risky logic or bug fixes (auth, money, parsers, writes, key branches) with no test that catches a break. Value one targeted test over coverage metrics.
- Speed: Flag real bottlenecks. Keep small hot-loop wins as optional suggestions.
- Lean:
  - Delete: Dead code, unused options, flags or config, speculative features.
  - Reuse and consolidate: Duplicate helpers, near-copies that must change together, or re-implementing a helper the repo already has (name its path).
  - Native: Dependencies (including new ones for a few lines) or custom code replaceable by stdlib or platform features.
  - YAGNI: Single-use interfaces, single-product factories, pass-through wrappers, config nobody sets.
  - Split: Functions or classes mixing unrelated jobs (split by job, never by line count).

## 3. Rules of Engagement

- Concrete proof only: Every finding needs a specific trigger (this input or state causes this failure). No concrete case, no finding.
- Verify before reporting: Re-read the lines to confirm callers exist, values can really be empty, and unused code is truly unused across the whole tree (including tests, config, and dynamic or string references).
- Respect explicit shortcuts: Comments like "shortcut:" stating a known limit are decisions, not findings, unless expected load already crosses that limit.
- Smallest fix: Prefer deleting code. Never suggest new layers, frameworks, or config the problem does not demand.
- No fluff: No style nitpicks, no "consider", no vague worries.

## 4. Output Format

Use short sentences and plain English. Explain technical terms the first time you use them.

Start with "What this does:" in two or three sentences, plus the load you assumed.

Number findings continuously across all groups so the user can say "fix 2 and 5". Skip empty groups.

### Must fix

- Bugs, security or data loss, breaks at assumed load.

### Should fix

- Untested risky logic, real slowdowns, bloat, mixed jobs, duplication.

### Nice to have

- Small speed-ups, minor simplifications.

### Finding format

Use this 4-part format for each finding (1 to 2 short sentences each):

1. Short descriptive title (path/to/file.ext:L10-25)

- What: What this code does.
- Problem: The concrete failure case or waste.
- Fix: The smallest working change (code snippet if helpful).
- If skipped: Real-world impact.

### End of report

- Verdict: One line stating "Ship.", "Healthy.", or what to fix first (for example, "Fix 1 and 3 first.").
- Lean: -N lines, -M dependencies possible (if applicable).
- Not checked: Parts you could not read or run.

If nothing is wrong, start with "What this does:", then say "Looks good. Ship." (for changes) or "Healthy. Nothing to fix." (for audits), followed by bullet points on what you checked.
