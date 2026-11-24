import { execFileSync } from "node:child_process";
import { createHash, randomBytes } from "node:crypto";
import {
  chmodSync,
  existsSync,
  mkdirSync,
  readFileSync,
  renameSync,
  rmSync,
  watch,
  writeFileSync,
  type FSWatcher,
} from "node:fs";
import { homedir } from "node:os";
import { basename, join, resolve } from "node:path";
import {
  normalizeFilePath,
  parseStoredReviewPlan,
  type ReviewPlan,
} from "./types.ts";

export interface PlanStoreSnapshot {
  readonly repoRoot: string | null;
  readonly plan: ReviewPlan | null;
  readonly serialized: string | null;
}

export interface AppliedPlanResult<T> {
  readonly files: T[];
  readonly matchedCount: number;
  readonly hiddenCount: number;
  readonly fallbackUsed: boolean;
}

/** Resolve the enclosing Git repository root, falling back to the resolved directory. */
export function resolveRepoRoot(directory: string): string {
  const abs = resolve(directory);
  try {
    const out = execFileSync(
      "git",
      ["-C", abs, "rev-parse", "--show-toplevel"],
      {
        encoding: "utf8",
        stdio: ["ignore", "pipe", "ignore"],
      },
    ).trim();
    if (out.length > 0) {
      return out;
    }
  } catch {
    // Outside a git repository or git unavailable.
  }
  return abs;
}

/**
 * Canonicalize a repository root path so Git for Windows (`C:/Users/...`) and
 * PowerShell (`c:\Users\...`) hash to the exact same state filename.
 */
export function canonicalizeRepoRoot(
  repoRoot: string,
  platform: NodeJS.Platform = process.platform,
): string {
  let normalized = repoRoot.trim().replace(/\\/g, "/");
  if (!/^[A-Za-z]:\//.test(normalized) && !normalized.startsWith("/")) {
    normalized = resolve(repoRoot).replace(/\\/g, "/");
  }
  normalized = normalized.replace(/\/+/g, "/");
  // Keep root `/` or drive root `C:/`, strip trailing slashes otherwise.
  if (normalized.length > 1 && !/^[A-Za-z]:\/$/.test(normalized)) {
    normalized = normalized.replace(/\/+$/, "");
  }
  if (platform === "win32") {
    normalized = normalized.toLowerCase();
  }
  return normalized;
}

/** Cross-platform state directory for persisted review plans. */
export function resolveStateDir(
  env: NodeJS.ProcessEnv = process.env,
  platform: NodeJS.Platform = process.platform,
  home: string = homedir(),
): string {
  const override = env.HUNK_REVIEW_PLAN_STATE_DIR?.trim();
  if (override) {
    return override;
  }
  const xdgState = env.XDG_STATE_HOME?.trim();
  if (xdgState) {
    return join(xdgState, "hunk", "hunk-review-plan");
  }
  if (platform === "win32") {
    const localAppData =
      env.LOCALAPPDATA?.trim() || join(home, "AppData", "Local");
    return join(localAppData, "hunk", "hunk-review-plan");
  }
  return join(home, ".local", "state", "hunk", "hunk-review-plan");
}

export function planFileName(
  repoRoot: string,
  platform: NodeJS.Platform = process.platform,
): string {
  const canonical = canonicalizeRepoRoot(repoRoot, platform);
  const digest = createHash("sha256").update(canonical).digest("hex");
  return `${digest.slice(0, 16)}.json`;
}

export function planFilePath(
  repoRoot: string,
  stateDir: string = resolveStateDir(),
  platform: NodeJS.Platform = process.platform,
): string {
  return join(stateDir, planFileName(repoRoot, platform));
}

function readRawPlanFile(filePath: string): {
  plan: ReviewPlan | null;
  serialized: string | null;
} {
  if (!existsSync(filePath)) {
    return { plan: null, serialized: null };
  }
  try {
    const raw = readFileSync(filePath, "utf8");
    const parsed = parseStoredReviewPlan(JSON.parse(raw));
    if (!parsed) {
      return { plan: null, serialized: null };
    }
    return { plan: parsed, serialized: raw };
  } catch {
    return { plan: null, serialized: null };
  }
}

export function loadPlan(
  repoRoot: string,
  stateDir: string = resolveStateDir(),
): ReviewPlan | null {
  return readRawPlanFile(planFilePath(repoRoot, stateDir)).plan;
}

function isRetryableRenameError(error: unknown): boolean {
  const code = (error as NodeJS.ErrnoException | null)?.code;
  return code === "EPERM" || code === "EBUSY" || code === "EACCES";
}

/** Atomically write a review plan to disk, handling Windows NTFS rename contention. */
export function savePlan(
  plan: ReviewPlan,
  stateDir: string = resolveStateDir(),
): string {
  mkdirSync(stateDir, { recursive: true });
  if (process.platform !== "win32") {
    try {
      chmodSync(stateDir, 0o700);
    } catch {
      // Best-effort permissions.
    }
  }

  const target = planFilePath(plan.repoRoot, stateDir);
  const serialized = `${JSON.stringify(plan, null, 2)}\n`;
  const temp = `${target}.${process.pid}.${randomBytes(4).toString("hex")}.tmp`;

  writeFileSync(temp, serialized, "utf8");

  let renamed = false;
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      renameSync(temp, target);
      renamed = true;
      break;
    } catch (error) {
      if (!isRetryableRenameError(error) || attempt === 2) {
        break;
      }
    }
  }

  if (!renamed) {
    try {
      writeFileSync(target, serialized, "utf8");
    } finally {
      try {
        rmSync(temp, { force: true });
      } catch {
        // Ignore temp cleanup failures.
      }
    }
  }

  if (process.platform !== "win32") {
    try {
      chmodSync(target, 0o600);
    } catch {
      // Best-effort permissions.
    }
  }

  return target;
}

export function clearPlan(
  repoRoot: string,
  stateDir: string = resolveStateDir(),
): boolean {
  const target = planFilePath(repoRoot, stateDir);
  if (!existsSync(target)) {
    return false;
  }
  rmSync(target, { force: true });
  return true;
}

/**
 * Reorder (and optionally filter) diff files according to an active ReviewPlan.
 * Always preserves the original file objects untouched (including opaque `metadata`).
 */
export function applyChangesetPlan<T extends { path: string }>(
  files: readonly T[],
  plan: ReviewPlan | null,
): AppliedPlanResult<T> {
  if (!plan || plan.files.length === 0) {
    return {
      files: [...files],
      matchedCount: 0,
      hiddenCount: 0,
      fallbackUsed: false,
    };
  }

  const byPath = new Map<string, T[]>();
  for (const file of files) {
    const key = normalizeFilePath(file.path);
    const bucket = byPath.get(key);
    if (bucket) {
      bucket.push(file);
    } else {
      byPath.set(key, [file]);
    }
  }

  const ordered: T[] = [];
  const consumed = new Set<string>();

  for (const entry of plan.files) {
    const key = normalizeFilePath(entry.path);
    if (consumed.has(key)) {
      continue;
    }
    const matches = byPath.get(key);
    if (matches) {
      consumed.add(key);
      ordered.push(...matches);
    }
  }

  const unlisted: T[] = [];
  for (const file of files) {
    const key = normalizeFilePath(file.path);
    if (!consumed.has(key)) {
      unlisted.push(file);
    }
  }

  if (plan.only) {
    if (ordered.length === 0 && files.length > 0) {
      return {
        files: [...files],
        matchedCount: 0,
        hiddenCount: 0,
        fallbackUsed: true,
      };
    }
    return {
      files: ordered,
      matchedCount: ordered.length,
      hiddenCount: unlisted.length,
      fallbackUsed: false,
    };
  }

  return {
    files: [...ordered, ...unlisted],
    matchedCount: ordered.length,
    hiddenCount: 0,
    fallbackUsed: false,
  };
}

export interface ReactivePlanStore {
  subscribe(listener: () => void): () => void;
  getSnapshot(): PlanStoreSnapshot;
  attach(
    repoRoot: string,
    onExternalChange: (plan: ReviewPlan | null) => void,
    stateDir?: string,
  ): ReviewPlan | null;
  reloadFromDisk(): ReviewPlan | null;
  updatePlan(plan: ReviewPlan | null, stateDir?: string): void;
  detach(): void;
}

/**
 * Module-level reactive store bridged into React via `useSyncExternalStore`
 * and synchronized with CLI writes through a debounced directory watcher.
 */
export function createPlanStore(): ReactivePlanStore {
  let snapshot: PlanStoreSnapshot = {
    repoRoot: null,
    plan: null,
    serialized: null,
  };
  let watchedDir: string | null = null;
  let watchedFile: string | null = null;
  let watcher: FSWatcher | null = null;
  let debounceTimer: ReturnType<typeof setTimeout> | null = null;
  let externalCallback: ((plan: ReviewPlan | null) => void) | null = null;
  const listeners = new Set<() => void>();

  function emitListeners() {
    for (const listener of listeners) {
      listener();
    }
  }

  function setSnapshot(next: PlanStoreSnapshot) {
    snapshot = next;
    emitListeners();
  }

  function refresh(notifyExternal: boolean): ReviewPlan | null {
    if (!snapshot.repoRoot || !watchedFile) {
      return null;
    }
    const { plan, serialized } = readRawPlanFile(watchedFile);
    if (serialized === snapshot.serialized) {
      return snapshot.plan;
    }
    setSnapshot({
      repoRoot: snapshot.repoRoot,
      plan,
      serialized,
    });
    if (notifyExternal && externalCallback) {
      externalCallback(plan);
    }
    return plan;
  }

  function detach() {
    if (debounceTimer !== null) {
      clearTimeout(debounceTimer);
      debounceTimer = null;
    }
    if (watcher) {
      try {
        watcher.close();
      } catch {
        // Ignore close errors during shutdown.
      }
      watcher = null;
    }
    externalCallback = null;
  }

  function attach(
    repoRoot: string,
    onExternalChange: (plan: ReviewPlan | null) => void,
    stateDir: string = resolveStateDir(),
  ): ReviewPlan | null {
    detach();

    mkdirSync(stateDir, { recursive: true });
    watchedDir = stateDir;
    watchedFile = planFilePath(repoRoot, stateDir);
    externalCallback = onExternalChange;

    const { plan, serialized } = readRawPlanFile(watchedFile);
    setSnapshot({ repoRoot, plan, serialized });

    const targetBase = basename(watchedFile);
    try {
      watcher = watch(watchedDir, (_eventType, filename) => {
        if (filename) {
          const name = filename.toString();
          const matches =
            process.platform === "win32"
              ? name.toLowerCase() === targetBase.toLowerCase()
              : name === targetBase;
          // Ignore temp files written for other repos, but allow null filenames
          // (common on some platforms) and exact target matches.
          if (!matches && !name.startsWith(targetBase)) {
            return;
          }
        }
        if (debounceTimer !== null) {
          clearTimeout(debounceTimer);
        }
        debounceTimer = setTimeout(() => {
          debounceTimer = null;
          refresh(true);
        }, 90);
      });
      watcher.on("error", () => {
        // Keep Hunk running cleanly if the watcher hits a transient OS error.
      });
    } catch {
      // If directory watching is unavailable, transforms still read from disk on reload.
    }

    return plan;
  }

  function updatePlan(
    plan: ReviewPlan | null,
    stateDir: string = watchedDir ?? resolveStateDir(),
  ) {
    const repoRoot = plan?.repoRoot ?? snapshot.repoRoot;
    if (!repoRoot) {
      return;
    }
    if (plan) {
      savePlan(plan, stateDir);
      const serialized = `${JSON.stringify(plan, null, 2)}\n`;
      setSnapshot({ repoRoot, plan, serialized });
    } else {
      clearPlan(repoRoot, stateDir);
      setSnapshot({ repoRoot, plan: null, serialized: null });
    }
  }

  return {
    subscribe(listener) {
      listeners.add(listener);
      return () => {
        listeners.delete(listener);
      };
    },
    getSnapshot() {
      return snapshot;
    },
    attach,
    reloadFromDisk() {
      return refresh(false);
    },
    updatePlan,
    detach,
  };
}
