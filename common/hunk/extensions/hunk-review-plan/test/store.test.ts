import { describe, expect, test } from "bun:test";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  applyChangesetPlan,
  canonicalizeRepoRoot,
  clearPlan,
  loadPlan,
  planFileName,
  resolveStateDir,
  savePlan,
} from "../src/store.ts";
import {
  normalizeFilePath,
  normalizeText,
  parseReviewPlanInput,
} from "../src/types.ts";

describe("types and cross-platform normalization", () => {
  test("normalizes Windows backslashes and leading ./ segments", () => {
    expect(normalizeFilePath(".\\src\\auth\\login.ts")).toBe(
      "src/auth/login.ts",
    );
    expect(normalizeFilePath("././packages//core/index.ts/")).toBe(
      "packages/core/index.ts",
    );
  });

  test("normalizes CRLF and CR line endings to LF", () => {
    expect(normalizeText("line 1\r\nline 2\rline 3")).toBe(
      "line 1\nline 2\nline 3",
    );
  });

  test("deduplicates paths while preserving first position and merging notes", () => {
    const plan = parseReviewPlanInput(
      {
        title: "  Auth refactor\r\n ",
        files: [
          { path: "src\\types.ts", summary: "Types" },
          { path: "./src/auth.ts", note: "First line\r\nSecond line" },
          { path: "src/types.ts", note: "Merged note" },
        ],
      },
      "/repo",
    );

    expect(plan.title).toBe("Auth refactor");
    expect(plan.only).toBe(false);
    expect(plan.files).toEqual([
      { path: "src/types.ts", summary: "Types", note: "Merged note" },
      { path: "src/auth.ts", note: "First line\nSecond line" },
    ]);
  });
});

describe("canonicalizeRepoRoot and resolveStateDir", () => {
  test("hashes Git for Windows and PowerShell repo roots identically on win32", () => {
    const fromGit = canonicalizeRepoRoot("C:/Users/Khalil/Work/MyRepo/", "win32");
    const fromPwsh = canonicalizeRepoRoot("c:\\Users\\khalil\\work\\myrepo\\", "win32");
    expect(fromGit).toBe(fromPwsh);
    expect(planFileName("C:/Users/Khalil/Work/MyRepo", "win32")).toBe(
      planFileName("c:\\Users\\khalil\\work\\myrepo", "win32"),
    );
  });

  test("selects LOCALAPPDATA on win32 when XDG_STATE_HOME is unset", () => {
    const dir = resolveStateDir(
      { LOCALAPPDATA: "C:\\Users\\khalil\\AppData\\Local" },
      "win32",
      "C:\\Users\\khalil",
    );
    expect(dir.replace(/\\/g, "/")).toBe(
      "C:/Users/khalil/AppData/Local/hunk/hunk-review-plan",
    );
  });

  test("prefers XDG_STATE_HOME on POSIX and Windows", () => {
    const dir = resolveStateDir(
      { XDG_STATE_HOME: "/tmp/xdg-state" },
      "linux",
      "/home/khalil",
    );
    expect(dir).toBe("/tmp/xdg-state/hunk/hunk-review-plan");
  });
});

describe("persistence and applyChangesetPlan", () => {
  test("saves, loads, and clears a plan in a temp state dir", () => {
    const dir = mkdtempSync(join(tmpdir(), "hunk-review-plan-test-"));
    try {
      const plan = parseReviewPlanInput(
        {
          title: "Test plan",
          only: true,
          files: [{ path: "b.ts", summary: "Start with B", note: "Details" }],
        },
        "/fake/repo",
      );

      savePlan(plan, dir);
      const loaded = loadPlan("/fake/repo", dir);
      expect(loaded).toEqual(plan);

      expect(clearPlan("/fake/repo", dir)).toBe(true);
      expect(clearPlan("/fake/repo", dir)).toBe(false);
      expect(loadPlan("/fake/repo", dir)).toBeNull();
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  test("orders listed files first and appends unlisted files by default while preserving metadata", () => {
    const metaA = { opaque: "a" };
    const metaB = { opaque: "b" };
    const metaC = { opaque: "c" };
    const diffFiles = [
      { id: "0", path: "a.ts", metadata: metaA },
      { id: "1", path: "b.ts", metadata: metaB },
      { id: "2", path: "c.ts", metadata: metaC },
    ];

    const plan = parseReviewPlanInput(
      { files: [{ path: "c.ts" }, { path: "missing.ts" }, { path: "a.ts" }] },
      "/fake/repo",
    );

    const result = applyChangesetPlan(diffFiles, plan);
    expect(result.fallbackUsed).toBe(false);
    expect(result.hiddenCount).toBe(0);
    expect(result.matchedCount).toBe(2);
    expect(result.files.map((f) => f.path)).toEqual(["c.ts", "a.ts", "b.ts"]);
    expect(result.files[0]!.metadata).toBe(metaC);
    expect(result.files[1]!.metadata).toBe(metaA);
    expect(result.files[2]!.metadata).toBe(metaB);
  });

  test("hides unlisted files when only is true", () => {
    const diffFiles = [
      { id: "0", path: "a.ts", metadata: {} },
      { id: "1", path: "b.ts", metadata: {} },
      { id: "2", path: "c.ts", metadata: {} },
    ];
    const plan = parseReviewPlanInput(
      { only: true, files: [{ path: "b.ts" }] },
      "/fake/repo",
    );

    const result = applyChangesetPlan(diffFiles, plan);
    expect(result.fallbackUsed).toBe(false);
    expect(result.files.map((f) => f.path)).toEqual(["b.ts"]);
    expect(result.hiddenCount).toBe(2);
  });

  test("falls back to showing all files if only plan matches zero diff files", () => {
    const diffFiles = [
      { id: "0", path: "a.ts", metadata: {} },
      { id: "1", path: "b.ts", metadata: {} },
    ];
    const plan = parseReviewPlanInput(
      { only: true, files: [{ path: "old.ts" }] },
      "/fake/repo",
    );

    const result = applyChangesetPlan(diffFiles, plan);
    expect(result.fallbackUsed).toBe(true);
    expect(result.files.map((f) => f.path)).toEqual(["a.ts", "b.ts"]);
  });
});
