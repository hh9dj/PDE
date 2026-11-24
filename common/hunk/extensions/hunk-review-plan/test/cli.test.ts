import { describe, expect, test } from "bun:test";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionCliCommandContext } from "hunkdiff/extension";
import { runPlanCli } from "../src/cli.ts";
import { loadPlan } from "../src/store.ts";

function createTestCliContext(
  cwd: string,
  stdinText = "",
): {
  ctx: ExtensionCliCommandContext;
  stdout: () => string;
  stderr: () => string;
} {
  let out = "";
  let err = "";
  const encoder = new TextEncoder();

  async function* stdinStream(): AsyncIterable<Uint8Array> {
    if (stdinText.length > 0) {
      yield encoder.encode(stdinText);
    }
  }

  const ctx: ExtensionCliCommandContext = {
    cwd,
    signal: new AbortController().signal,
    stdin: stdinStream(),
    stdout: {
      async write(chunk) {
        out +=
          typeof chunk === "string"
            ? chunk
            : Buffer.from(chunk).toString("utf8");
      },
    },
    stderr: {
      async write(chunk) {
        err +=
          typeof chunk === "string"
            ? chunk
            : Buffer.from(chunk).toString("utf8");
      },
    },
  };

  return {
    ctx,
    stdout: () => out,
    stderr: () => err,
  };
}

describe("hunk plan CLI", () => {
  test("set --stdin parses BOM + CRLF JSON, show displays it, and clear removes it", async () => {
    const dir = mkdtempSync(join(tmpdir(), "hunk-plan-cli-"));
    const repoDir = join(dir, "repo");
    const stateDir = join(dir, "state");

    try {
      // Prefix UTF-8 BOM + CRLF as Windows PowerShell may emit.
      const payload =
        "\uFEFF" +
        JSON.stringify({
          title: "Feature walkthrough",
          only: false,
          files: [
            {
              path: "src\\schema.ts",
              summary: "Schema changes",
              note: "Line 1\r\nLine 2",
            },
            {
              path: "./src/handler.ts",
              summary: "Wire handler",
            },
          ],
        });

      const setRun = createTestCliContext(dir, payload);
      const setCode = await runPlanCli(
        ["set", "--repo", repoDir, "--stdin", "--json"],
        setRun.ctx,
        { stateDir },
      );
      expect(setCode).toBe(0);
      expect(setRun.stderr()).toBe("");
      const setOut = JSON.parse(setRun.stdout());
      expect(setOut.ok).toBe(true);
      expect(setOut.plan.files).toEqual([
        {
          path: "src/schema.ts",
          summary: "Schema changes",
          note: "Line 1\nLine 2",
        },
        {
          path: "src/handler.ts",
          summary: "Wire handler",
        },
      ]);

      const showRun = createTestCliContext(dir);
      const showCode = await runPlanCli(
        ["show", "--repo", repoDir, "--json"],
        showRun.ctx,
        { stateDir },
      );
      expect(showCode).toBe(0);
      expect(JSON.parse(showRun.stdout()).plan.title).toBe(
        "Feature walkthrough",
      );

      const clearRun = createTestCliContext(dir);
      const clearCode = await runPlanCli(
        ["clear", "--repo", repoDir, "--json"],
        clearRun.ctx,
        { stateDir },
      );
      expect(clearCode).toBe(0);
      expect(JSON.parse(clearRun.stdout()).cleared).toBe(true);
      expect(loadPlan(repoDir, stateDir)).toBeNull();
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  test("positional set preserves existing notes and note --position reorders", async () => {
    const dir = mkdtempSync(join(tmpdir(), "hunk-plan-cli-"));
    const repoDir = join(dir, "repo");
    const stateDir = join(dir, "state");

    try {
      const noteRun1 = createTestCliContext(dir);
      expect(
        await runPlanCli(
          [
            "note",
            "--repo",
            repoDir,
            "--file",
            "src\\b.ts",
            "--summary",
            "Core logic",
            "--note",
            "Main implementation",
          ],
          noteRun1.ctx,
          { stateDir },
        ),
      ).toBe(0);

      const setOrder = createTestCliContext(dir);
      expect(
        await runPlanCli(
          ["set", "--repo", repoDir, "--only", "src/a.ts", "src/b.ts"],
          setOrder.ctx,
          { stateDir },
        ),
      ).toBe(0);

      let plan = loadPlan(repoDir, stateDir)!;
      expect(plan.only).toBe(true);
      expect(plan.files).toEqual([
        { path: "src/a.ts" },
        {
          path: "src/b.ts",
          summary: "Core logic",
          note: "Main implementation",
        },
      ]);

      const moveRun = createTestCliContext(dir, "Multi-line\r\nnote body");
      expect(
        await runPlanCli(
          [
            "note",
            "--repo",
            repoDir,
            "--file",
            "src/c.ts",
            "--position",
            "1",
            "--stdin",
          ],
          moveRun.ctx,
          { stateDir },
        ),
      ).toBe(0);

      plan = loadPlan(repoDir, stateDir)!;
      expect(plan.files.map((f) => f.path)).toEqual([
        "src/c.ts",
        "src/a.ts",
        "src/b.ts",
      ]);
      expect(plan.files[0]!.note).toBe("Multi-line\nnote body");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  test("rejects unknown subcommand and invalid JSON cleanly", async () => {
    const dir = mkdtempSync(join(tmpdir(), "hunk-plan-cli-"));
    const stateDir = join(dir, "state");

    try {
      const badCmd = createTestCliContext(dir);
      expect(await runPlanCli(["bogus"], badCmd.ctx, { stateDir })).toBe(1);
      expect(badCmd.stderr()).toContain("Unknown subcommand");

      const badJson = createTestCliContext(dir, "{not valid json");
      expect(
        await runPlanCli(["set", "--stdin"], badJson.ctx, { stateDir }),
      ).toBe(1);
      expect(badJson.stderr()).toContain("Invalid JSON");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});
