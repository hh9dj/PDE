import { useEffect, useSyncExternalStore } from "react";
import type { ExtensionPaneProps } from "hunkdiff/extension";
import type { ReactivePlanStore } from "./store.ts";
import { normalizeFilePath, type ReviewPlanFileEntry } from "./types.ts";

/** Wrap multi-line text to terminal width while preserving explicit line breaks. */
export function wrapNoteLines(text: string, maxWidth: number): string[] {
  const width = Math.max(20, maxWidth);
  const result: string[] = [];

  for (const rawLine of text.split("\n")) {
    if (rawLine.trim().length === 0) {
      result.push("");
      continue;
    }

    const indentMatch = rawLine.match(/^(\s*)/);
    const indent = indentMatch ? indentMatch[1]! : "";
    const content = rawLine.slice(indent.length);
    const words = content.split(/\s+/);
    let current = indent;

    for (const word of words) {
      if (current === indent) {
        if (indent.length + word.length <= width) {
          current += word;
        } else {
          // Break single oversized token across lines.
          let remaining = word;
          while (remaining.length > 0) {
            const avail = Math.max(1, width - indent.length);
            result.push(`${indent}${remaining.slice(0, avail)}`);
            remaining = remaining.slice(avail);
          }
          current = indent;
        }
        continue;
      }

      if (current.length + 1 + word.length <= width) {
        current += ` ${word}`;
      } else {
        result.push(current);
        if (indent.length + word.length <= width) {
          current = `${indent}${word}`;
        } else {
          let remaining = word;
          while (remaining.length > 0) {
            const avail = Math.max(1, width - indent.length);
            result.push(`${indent}${remaining.slice(0, avail)}`);
            remaining = remaining.slice(avail);
          }
          current = indent;
        }
      }
    }

    if (current !== indent) {
      result.push(current);
    }
  }

  return result;
}

function truncateLine(text: string, maxWidth: number): string {
  if (maxWidth <= 0) return "";
  if (text.length <= maxWidth) return text;
  if (maxWidth <= 3) return text.slice(0, maxWidth);
  return `${text.slice(0, maxWidth - 1)}…`;
}

export interface ReviewNotePaneOptions {
  onResolvedToggleKey?: (key: string | null) => void;
}

export function createReviewNotePane(
  store: ReactivePlanStore,
  options?: ReviewNotePaneOptions,
) {
  return function ReviewNotePane({
    files,
    selectedFileId,
    width,
    theme,
    keybindings,
  }: ExtensionPaneProps) {
    const snapshot = useSyncExternalStore(store.subscribe, store.getSnapshot);
    const plan = snapshot.plan;
    const innerWidth = Math.max(20, width - 2);

    const selectedFile =
      selectedFileId !== null
        ? (files.find((f) => f.id === selectedFileId) ?? null)
        : null;

    const toggleKeys = keybindings.getKeys("hunk-review-plan.toggle-notes");
    const primaryToggleKey = toggleKeys[0] ?? null;
    const toggleHint = primaryToggleKey ? `[${primaryToggleKey}]` : "";

    useEffect(() => {
      options?.onResolvedToggleKey?.(primaryToggleKey);
    }, [primaryToggleKey]);

    let stepIndex = -1;
    let entry: ReviewPlanFileEntry | null = null;

    if (plan && selectedFile) {
      const normalizedSelected = normalizeFilePath(selectedFile.path);
      stepIndex = plan.files.findIndex(
        (item) => normalizeFilePath(item.path) === normalizedSelected,
      );
      if (stepIndex >= 0) {
        entry = plan.files[stepIndex]!;
      }
    }

    const headerParts: string[] = [];
    if (plan) {
      if (selectedFile && stepIndex >= 0) {
        headerParts.push(`[${stepIndex + 1}/${plan.files.length}]`);
      } else if (selectedFile) {
        headerParts.push("[unlisted]");
      } else {
        headerParts.push(`[${plan.files.length} planned]`);
      }
    } else {
      headerParts.push("[no plan]");
    }

    if (selectedFile) {
      headerParts.push(selectedFile.path);
    }
    if (plan?.title) {
      headerParts.push(`· ${plan.title}`);
    }
    if (plan?.only) {
      headerParts.push("· only");
    }
    if (toggleHint) {
      headerParts.push(`· hide ${toggleHint}`);
    }

    const headerLine = truncateLine(headerParts.join(" "), innerWidth);

    const bodyLines: Array<{ key: string; text: string; fg: string }> = [];

    if (!selectedFile) {
      bodyLines.push({
        key: "empty-selection",
        text: "No file selected.",
        fg: theme.muted,
      });
    } else if (!plan) {
      for (const [idx, line] of wrapNoteLines(
        "No review plan active for this repository. Run `hunk plan set` to order files and attach per-file notes.",
        innerWidth,
      ).entries()) {
        bodyLines.push({
          key: `no-plan-${idx}`,
          text: line,
          fg: theme.muted,
        });
      }
    } else {
      if (entry?.summary) {
        for (const [idx, line] of wrapNoteLines(
          entry.summary,
          innerWidth,
        ).entries()) {
          bodyLines.push({
            key: `summary-${idx}`,
            text: line,
            fg: theme.accent,
          });
        }
      }

      if (entry?.note) {
        if (entry.summary) {
          bodyLines.push({ key: "spacer", text: "", fg: theme.text });
        }
        for (const [idx, line] of wrapNoteLines(
          entry.note,
          innerWidth,
        ).entries()) {
          bodyLines.push({
            key: `note-${idx}`,
            text: line,
            fg: theme.text,
          });
        }
      } else if (!entry?.summary) {
        const msg =
          stepIndex >= 0
            ? "No note attached for this file. Use `hunk plan note --file <path> --note <text>` to add one."
            : "This file is not listed in the active review plan.";
        for (const [idx, line] of wrapNoteLines(msg, innerWidth).entries()) {
          bodyLines.push({
            key: `missing-note-${idx}`,
            text: line,
            fg: theme.muted,
          });
        }
      }
    }

    return (
      <box
        style={{
          width: "100%",
          height: "100%",
          flexDirection: "column",
          bg: theme.panel,
        }}
      >
        <box style={{ width: "100%", height: 1, bg: theme.panel }}>
          <text
            content={` ${headerLine}`}
            style={{ fg: theme.accent, bg: theme.panel }}
          />
        </box>
        <scrollbox scrollY={true} width="100%" height="100%" focused={false}>
          {bodyLines.map((row) => (
            <text
              key={row.key}
              content={row.text.length > 0 ? ` ${row.text}` : " "}
              style={{ fg: row.fg, bg: theme.panel }}
            />
          ))}
        </scrollbox>
      </box>
    );
  };
}
