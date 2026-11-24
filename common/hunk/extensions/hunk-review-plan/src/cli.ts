import type { ExtensionCliCommandContext } from "hunkdiff/extension";
import {
  clearPlan,
  loadPlan,
  resolveRepoRoot,
  resolveStateDir,
  savePlan,
} from "./store.ts";
import {
  normalizeFilePath,
  normalizeText,
  parseReviewPlanInput,
  type ReviewPlan,
  type ReviewPlanFileEntry,
} from "./types.ts";

export const PLAN_CLI_USAGE = "<set|note|show|clear> [options]";

const HELP_TEXT = `Usage:
  hunk plan set [--repo <path>] [--title <text>] [--only|--all] --stdin [--json]
  hunk plan set [--repo <path>] [--title <text>] [--only|--all] [--json] [--] <file...>
  hunk plan note [--repo <path>] --file <path> (--note <text> | --stdin) [--summary <text>] [--position <n>] [--json]
  hunk plan show [--repo <path>] [--json]
  hunk plan clear [--repo <path>] [--json]

Manage the review file order and per-file notes shown in Hunk's bottom notes pane.

Commands:
  set    Set the ordered file list (and optionally notes via JSON on --stdin).
  note   Add or update a single file's summary or note (and optional 1-based position).
  show   Show the active review plan for a repository.
  clear  Remove the stored review plan and restore default Hunk ordering.

Options:
  --repo <path>      Target repository directory (default: current directory).
  --title <text>     Optional title for the review plan.
  --only             Hide diff files not listed in the plan.
  --all              Keep unlisted diff files appended at the end (default).
  --stdin            Read JSON plan (for set) or note body (for note) from stdin.
  --file <path>      Repository-relative path for 'note'.
  --summary <text>   Short one-line headline for 'note'.
  --note <text>      Detailed explanation text for 'note'.
  --position <n>     1-based position in the review order for 'note'.
  --json             Output machine-readable JSON.
  --help, -h         Show this help text.
`;

async function readStdin(
  stdin: AsyncIterable<Uint8Array>,
  signal: AbortSignal,
): Promise<string> {
  const chunks: Buffer[] = [];
  for await (const chunk of stdin) {
    if (signal.aborted) {
      throw new Error("Aborted while reading stdin");
    }
    chunks.push(Buffer.from(chunk));
  }
  const text = Buffer.concat(chunks).toString("utf8");
  // Strip UTF-8 BOM if emitted by PowerShell or Windows tooling.
  return text.replace(/^\uFEFF/, "");
}

function nextValue(
  args: readonly string[],
  index: number,
  flag: string,
): { value: string; nextIndex: number } {
  const value = args[index + 1];
  if (value === undefined) {
    throw new Error(`Missing value for ${flag}`);
  }
  return { value, nextIndex: index + 1 };
}

function formatPlanText(plan: ReviewPlan): string {
  const lines: string[] = [];
  const header = plan.title
    ? `Review plan: ${plan.title}`
    : `Review plan (${plan.repoRoot})`;
  lines.push(header);
  lines.push(
    `Mode: ${plan.only ? "only listed files" : "ordered first, unlisted appended"} | Files: ${plan.files.length}`,
  );
  if (plan.files.length === 0) {
    lines.push("(no files listed)");
    return `${lines.join("\n")}\n`;
  }
  lines.push("");
  plan.files.forEach((entry, idx) => {
    const headline = entry.summary
      ? `${idx + 1}. ${entry.path} — ${entry.summary}`
      : `${idx + 1}. ${entry.path}`;
    lines.push(headline);
    if (entry.note) {
      for (const noteLine of entry.note.split("\n")) {
        lines.push(`   ${noteLine}`);
      }
    }
  });
  return `${lines.join("\n")}\n`;
}

async function handleSet(
  args: readonly string[],
  ctx: ExtensionCliCommandContext,
  stateDir: string,
): Promise<number> {
  let repoArg = ctx.cwd;
  let title: string | undefined;
  let onlyFlag: boolean | undefined;
  let useStdin = false;
  let asJson = false;
  const positional: string[] = [];
  let afterDoubleDash = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i]!;
    if (afterDoubleDash) {
      positional.push(arg);
      continue;
    }
    if (arg === "--") {
      afterDoubleDash = true;
      continue;
    }
    if (arg === "--help" || arg === "-h") {
      await ctx.stdout.write(HELP_TEXT);
      return 0;
    }
    if (arg === "--repo") {
      const res = nextValue(args, i, "--repo");
      repoArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--title") {
      const res = nextValue(args, i, "--title");
      title = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--only") {
      onlyFlag = true;
      continue;
    }
    if (arg === "--all") {
      onlyFlag = false;
      continue;
    }
    if (arg === "--stdin") {
      useStdin = true;
      continue;
    }
    if (arg === "--json") {
      asJson = true;
      continue;
    }
    if (arg.startsWith("-")) {
      throw new Error(`Unknown option for 'set': ${arg}`);
    }
    positional.push(arg);
  }

  const repoRoot = resolveRepoRoot(repoArg);
  let plan: ReviewPlan;

  if (useStdin) {
    if (positional.length > 0) {
      throw new Error("Do not pass positional file paths together with --stdin");
    }
    const rawText = (await readStdin(ctx.stdin, ctx.signal)).trim();
    if (!rawText) {
      throw new Error("Empty stdin: expected a JSON review plan object");
    }
    let parsed: unknown;
    try {
      parsed = JSON.parse(rawText);
    } catch (error) {
      throw new Error(
        `Invalid JSON on stdin: ${error instanceof Error ? error.message : String(error)}`,
      );
    }
    plan = parseReviewPlanInput(parsed, repoRoot, {
      ...(onlyFlag !== undefined ? { only: onlyFlag } : {}),
      ...(title !== undefined ? { title } : {}),
    });
  } else {
    if (positional.length === 0) {
      throw new Error(
        "Specify file paths or pass --stdin with a JSON review plan",
      );
    }
    const existing = loadPlan(repoRoot, stateDir);
    const existingByPath = new Map<string, ReviewPlanFileEntry>();
    for (const entry of existing?.files ?? []) {
      existingByPath.set(normalizeFilePath(entry.path), entry);
    }

    const files = positional.map((rawPath) => {
      const path = normalizeFilePath(rawPath);
      const prev = existingByPath.get(path);
      return {
        path,
        ...(prev?.summary ? { summary: prev.summary } : {}),
        ...(prev?.note ? { note: prev.note } : {}),
      };
    });

    plan = parseReviewPlanInput(
      {
        title: title ?? existing?.title,
        only: onlyFlag ?? existing?.only ?? false,
        files,
      },
      repoRoot,
    );
  }

  const stateFile = savePlan(plan, stateDir);

  if (asJson) {
    await ctx.stdout.write(
      `${JSON.stringify({ ok: true, stateFile, plan }, null, 2)}\n`,
    );
  } else {
    const mode = plan.only ? "only listed" : "ordered + unlisted appended";
    await ctx.stdout.write(
      `Saved review plan for ${repoRoot}: ${plan.files.length} file(s) (${mode}).\n`,
    );
  }
  return 0;
}

async function handleNote(
  args: readonly string[],
  ctx: ExtensionCliCommandContext,
  stateDir: string,
): Promise<number> {
  let repoArg = ctx.cwd;
  let fileArg: string | undefined;
  let summaryArg: string | undefined;
  let noteArg: string | undefined;
  let useStdin = false;
  let positionArg: number | undefined;
  let asJson = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i]!;
    if (arg === "--help" || arg === "-h") {
      await ctx.stdout.write(HELP_TEXT);
      return 0;
    }
    if (arg === "--repo") {
      const res = nextValue(args, i, "--repo");
      repoArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--file") {
      const res = nextValue(args, i, "--file");
      fileArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--summary") {
      const res = nextValue(args, i, "--summary");
      summaryArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--note") {
      const res = nextValue(args, i, "--note");
      noteArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--stdin") {
      useStdin = true;
      continue;
    }
    if (arg === "--position") {
      const res = nextValue(args, i, "--position");
      const parsed = Number(res.value);
      if (!Number.isInteger(parsed) || parsed < 1) {
        throw new Error("--position must be a positive integer (1-based)");
      }
      positionArg = parsed;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--json") {
      asJson = true;
      continue;
    }
    throw new Error(`Unknown option for 'note': ${arg}`);
  }

  if (!fileArg) {
    throw new Error("Missing required option: --file <path>");
  }
  if (useStdin && noteArg !== undefined) {
    throw new Error("Specify either --note or --stdin, not both");
  }
  if (useStdin) {
    noteArg = await readStdin(ctx.stdin, ctx.signal);
  }
  if (summaryArg === undefined && noteArg === undefined && positionArg === undefined) {
    throw new Error("Provide at least one of --note, --stdin, --summary, or --position");
  }

  const filePath = normalizeFilePath(fileArg);
  if (!filePath) {
    throw new Error("--file must not be empty");
  }

  const repoRoot = resolveRepoRoot(repoArg);
  const existing = loadPlan(repoRoot, stateDir);
  const files: ReviewPlanFileEntry[] = [...(existing?.files ?? [])];

  const existingIndex = files.findIndex(
    (entry) => normalizeFilePath(entry.path) === filePath,
  );
  const prev = existingIndex >= 0 ? files[existingIndex] : undefined;

  const nextSummary =
    summaryArg !== undefined
      ? normalizeText(summaryArg).replace(/\s+/g, " ").trim() || undefined
      : prev?.summary;
  const nextNote =
    noteArg !== undefined
      ? normalizeText(noteArg).trim() || undefined
      : prev?.note;

  const updatedEntry: ReviewPlanFileEntry = {
    path: filePath,
    ...(nextSummary ? { summary: nextSummary } : {}),
    ...(nextNote ? { note: nextNote } : {}),
  };

  if (existingIndex >= 0) {
    files.splice(existingIndex, 1);
  }

  if (positionArg !== undefined) {
    const insertAt = Math.min(positionArg - 1, files.length);
    files.splice(insertAt, 0, updatedEntry);
  } else if (existingIndex >= 0) {
    files.splice(existingIndex, 0, updatedEntry);
  } else {
    files.push(updatedEntry);
  }

  const plan: ReviewPlan = {
    version: 1,
    repoRoot,
    ...(existing?.title ? { title: existing.title } : {}),
    only: existing?.only ?? false,
    updatedAt: new Date().toISOString(),
    files,
  };

  const stateFile = savePlan(plan, stateDir);
  const stepIndex = files.findIndex((entry) => entry.path === filePath) + 1;

  if (asJson) {
    await ctx.stdout.write(
      `${JSON.stringify({ ok: true, stateFile, step: stepIndex, entry: updatedEntry, plan }, null, 2)}\n`,
    );
  } else {
    await ctx.stdout.write(
      `Updated note for ${filePath} (step ${stepIndex}/${files.length}).\n`,
    );
  }
  return 0;
}

async function handleShow(
  args: readonly string[],
  ctx: ExtensionCliCommandContext,
  stateDir: string,
): Promise<number> {
  let repoArg = ctx.cwd;
  let asJson = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i]!;
    if (arg === "--help" || arg === "-h") {
      await ctx.stdout.write(HELP_TEXT);
      return 0;
    }
    if (arg === "--repo") {
      const res = nextValue(args, i, "--repo");
      repoArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--json") {
      asJson = true;
      continue;
    }
    throw new Error(`Unknown option for 'show': ${arg}`);
  }

  const repoRoot = resolveRepoRoot(repoArg);
  const plan = loadPlan(repoRoot, stateDir);

  if (asJson) {
    await ctx.stdout.write(`${JSON.stringify({ repoRoot, plan }, null, 2)}\n`);
    return 0;
  }

  if (!plan) {
    await ctx.stdout.write(`No review plan set for ${repoRoot}.\n`);
    return 0;
  }

  await ctx.stdout.write(formatPlanText(plan));
  return 0;
}

async function handleClear(
  args: readonly string[],
  ctx: ExtensionCliCommandContext,
  stateDir: string,
): Promise<number> {
  let repoArg = ctx.cwd;
  let asJson = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i]!;
    if (arg === "--help" || arg === "-h") {
      await ctx.stdout.write(HELP_TEXT);
      return 0;
    }
    if (arg === "--repo") {
      const res = nextValue(args, i, "--repo");
      repoArg = res.value;
      i = res.nextIndex;
      continue;
    }
    if (arg === "--json") {
      asJson = true;
      continue;
    }
    throw new Error(`Unknown option for 'clear': ${arg}`);
  }

  const repoRoot = resolveRepoRoot(repoArg);
  const cleared = clearPlan(repoRoot, stateDir);

  if (asJson) {
    await ctx.stdout.write(
      `${JSON.stringify({ ok: true, repoRoot, cleared }, null, 2)}\n`,
    );
  } else if (cleared) {
    await ctx.stdout.write(`Cleared review plan for ${repoRoot}.\n`);
  } else {
    await ctx.stdout.write(`No review plan was set for ${repoRoot}.\n`);
  }
  return 0;
}

export async function runPlanCli(
  args: readonly string[],
  ctx: ExtensionCliCommandContext,
  options?: { stateDir?: string },
): Promise<number> {
  const stateDir = options?.stateDir ?? resolveStateDir();
  const [subcommand, ...rest] = args;

  if (!subcommand || subcommand === "--help" || subcommand === "-h") {
    await ctx.stdout.write(HELP_TEXT);
    return 0;
  }

  try {
    switch (subcommand) {
      case "set":
        return await handleSet(rest, ctx, stateDir);
      case "note":
        return await handleNote(rest, ctx, stateDir);
      case "show":
        return await handleShow(rest, ctx, stateDir);
      case "clear":
        return await handleClear(rest, ctx, stateDir);
      default:
        await ctx.stderr.write(
          `Unknown subcommand: ${subcommand}\nRun 'hunk plan --help' for usage.\n`,
        );
        return 1;
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    await ctx.stderr.write(`hunk plan: ${message}\n`);
    return 1;
  }
}
