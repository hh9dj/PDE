import type {
  ExtensionStatusLineControls,
  HunkExtensionAPI,
} from "hunkdiff/extension";
import { PLAN_CLI_USAGE, runPlanCli } from "./cli.ts";
import { formatPrimaryKey, parseExtensionConfig } from "./config.ts";
import { createReviewNotePane } from "./pane.tsx";
import {
  applyChangesetPlan,
  createPlanStore,
  loadPlan,
  resolveRepoRoot,
} from "./store.ts";
import { normalizeFilePath, type ReviewPlan } from "./types.ts";

interface PlanChangedEvent {
  readonly source: "watch" | "command";
  readonly action: "updated" | "toggled-only" | "cleared";
  readonly only?: boolean;
  readonly fileCount: number;
}

const PLAN_CHANGED_EVENT = "hunk-review-plan:plan-changed";
const STATUS_ITEM_ID = "plan";

function updateStatusLine(
  statusLine: ExtensionStatusLineControls | undefined,
  plan: ReviewPlan | null,
  currentFilePath: string | null,
): void {
  if (!statusLine) {
    return;
  }
  if (!plan || plan.files.length === 0) {
    statusLine.clear(STATUS_ITEM_ID);
    return;
  }

  let stepLabel = `${plan.files.length} files`;
  if (currentFilePath) {
    const normalized = normalizeFilePath(currentFilePath);
    const idx = plan.files.findIndex(
      (entry) => normalizeFilePath(entry.path) === normalized,
    );
    stepLabel =
      idx >= 0 ? `${idx + 1}/${plan.files.length}` : `unlisted/${plan.files.length}`;
  }

  const spans = [
    { text: `plan ${stepLabel}`, tone: "accent" as const },
    ...(plan.only ? [{ text: " [only]", tone: "muted" as const }] : []),
  ];

  statusLine.set({
    id: STATUS_ITEM_ID,
    alignment: "right",
    priority: 10,
    spans,
  });
}

export default function registerHunkReviewPlan(hunk: HunkExtensionAPI) {
  const store = createPlanStore();
  const repoRootCache = new Map<string, string>();
  let currentFilePath: string | null = null;
  let lastFallbackSignature: string | null = null;

  const extConfig = parseExtensionConfig(hunk.config);
  const autoOpen = extConfig.autoOpen;
  let resolvedToggleNotesKey = formatPrimaryKey(
    extConfig.keybindings.toggleNotes,
  );

  function getRepoRoot(cwd: string): string {
    const cached = repoRootCache.get(cwd);
    if (cached) {
      return cached;
    }
    const resolved = resolveRepoRoot(cwd);
    repoRootCache.set(cwd, resolved);
    return resolved;
  }

  hunk.registerCliCommand(
    {
      name: "plan",
      summary: "Order diff files and attach per-file review notes",
      usage: PLAN_CLI_USAGE,
    },
    async (args, ctx) => ({
      kind: "exit",
      code: await runPlanCli(args, ctx),
    }),
  );

  hunk.transformChangeset((changeset, ctx) => {
    const repoRoot = store.getSnapshot().repoRoot ?? getRepoRoot(ctx.cwd);
    const plan =
      store.getSnapshot().repoRoot === repoRoot
        ? store.reloadFromDisk()
        : loadPlan(repoRoot);

    if (!plan || plan.files.length === 0) {
      lastFallbackSignature = null;
      return changeset;
    }

    const applied = applyChangesetPlan(changeset.files, plan);
    if (applied.fallbackUsed) {
      const signature = `${plan.updatedAt}:${changeset.files.length}`;
      if (lastFallbackSignature !== signature) {
        lastFallbackSignature = signature;
        ctx.notify(
          "Review plan --only matched no files in this diff; showing all files",
          "warning",
        );
      }
      return changeset;
    }

    lastFallbackSignature = null;
    return {
      ...changeset,
      files: applied.files,
    };
  });

  const ReviewNotePane = createReviewNotePane(store, {
    onResolvedToggleKey(key) {
      resolvedToggleNotesKey = key;
    },
  });

  hunk.registerPane({
    id: "notes",
    title: "Review note",
    placement: "bottom",
    height: { preferred: 7, min: 3, max: 18 },
    defaultOpen: false,
    component: ReviewNotePane,
  });

  hunk.registerCommand(
    {
      id: "toggle-notes",
      title: "Toggle review note pane",
      ...(extConfig.keybindings.toggleNotes !== undefined
        ? { key: extConfig.keybindings.toggleNotes }
        : {}),
    },
    (ctx) => {
      ctx.panes.toggle("notes");
    },
  );

  hunk.registerCommand(
    {
      id: "toggle-only",
      title: "Toggle planned files only",
      ...(extConfig.keybindings.toggleOnly !== undefined
        ? { key: extConfig.keybindings.toggleOnly }
        : {}),
    },
    (ctx) => {
      const repoRoot = store.getSnapshot().repoRoot ?? getRepoRoot(ctx.cwd);
      const current = loadPlan(repoRoot);
      if (!current || current.files.length === 0) {
        ctx.notify("No review plan active for this repository", "warning");
        return;
      }

      const updated: ReviewPlan = {
        ...current,
        only: !current.only,
        updatedAt: new Date().toISOString(),
      };
      store.updatePlan(updated);
      hunk.events.emit<PlanChangedEvent>(PLAN_CHANGED_EVENT, {
        source: "command",
        action: "toggled-only",
        only: updated.only,
        fileCount: updated.files.length,
      });
    },
  );

  hunk.registerCommand(
    {
      id: "clear-plan",
      title: "Clear review plan",
      ...(extConfig.keybindings.clearPlan !== undefined
        ? { key: extConfig.keybindings.clearPlan }
        : {}),
    },
    (ctx) => {
      const repoRoot = store.getSnapshot().repoRoot ?? getRepoRoot(ctx.cwd);
      const current = loadPlan(repoRoot);
      if (!current) {
        ctx.notify("No review plan is active for this repository");
        return;
      }
      store.updatePlan(null);
      updateStatusLine(ctx.statusLine, null, null);
      hunk.events.emit<PlanChangedEvent>(PLAN_CHANGED_EVENT, {
        source: "command",
        action: "cleared",
        fileCount: 0,
      });
    },
  );

  hunk.events.on<PlanChangedEvent>(PLAN_CHANGED_EVENT, async (payload, ctx) => {
    const snapshot = store.getSnapshot();
    updateStatusLine(ctx.statusLine, snapshot.plan, currentFilePath);

    const reloadResult = await ctx.review.requestReload();
    if (!reloadResult.ok && reloadResult.reason === "failed") {
      ctx.notify(
        `Review plan reload failed: ${reloadResult.detail}`,
        "warning",
      );
      return;
    }

    if (payload.action === "cleared") {
      ctx.notify("Review plan cleared");
      return;
    }

    if (payload.action === "toggled-only") {
      ctx.notify(
        payload.only
          ? "Showing only files in the review plan"
          : "Showing all files (planned files first)",
      );
      return;
    }

    if (payload.fileCount === 0) {
      ctx.notify("Review plan cleared");
      return;
    }

    if (autoOpen && payload.source === "watch") {
      ctx.panes.open("notes");
    }

    const modeHint = snapshot.plan?.only ? ", only listed" : "";
    const keyHint = resolvedToggleNotesKey
      ? ` — press ${resolvedToggleNotesKey} for notes`
      : "";
    ctx.notify(
      `Review plan updated (${payload.fileCount} files${modeHint})${keyHint}`,
    );
  });

  hunk.on("startup", (event, ctx) => {
    const repoRoot = getRepoRoot(event.cwd);
    const initialPlan = store.attach(repoRoot, (nextPlan) => {
      hunk.events.emit<PlanChangedEvent>(PLAN_CHANGED_EVENT, {
        source: "watch",
        action: nextPlan ? "updated" : "cleared",
        fileCount: nextPlan?.files.length ?? 0,
      });
    });

    updateStatusLine(ctx.statusLine, initialPlan, currentFilePath);
    if (autoOpen && initialPlan && initialPlan.files.length > 0) {
      ctx.panes.open("notes");
    }
  });

  hunk.on("changeset_loaded", (event, ctx) => {
    const plan = store.reloadFromDisk();
    if (!currentFilePath && event.changeset.files.length > 0) {
      currentFilePath = event.changeset.files[0]!.path;
    }
    updateStatusLine(ctx.statusLine, plan, currentFilePath);
  });

  hunk.on("file_viewed", (event, ctx) => {
    currentFilePath = event.file.path;
    updateStatusLine(ctx.statusLine, store.getSnapshot().plan, currentFilePath);
  });

  hunk.on("shutdown", () => {
    store.detach();
  });
}
