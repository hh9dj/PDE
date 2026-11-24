export type KeyBindingValue = string | string[] | undefined;

export interface ReviewPlanKeybindingsConfig {
  readonly toggleNotes: KeyBindingValue;
  readonly toggleOnly: KeyBindingValue;
  readonly clearPlan: KeyBindingValue;
}

export interface ReviewPlanExtensionConfig {
  readonly autoOpen: boolean;
  readonly keybindings: ReviewPlanKeybindingsConfig;
}

export const DEFAULT_KEYBINDINGS: ReviewPlanKeybindingsConfig = {
  toggleNotes: "alt+n",
  toggleOnly: "alt+o",
  clearPlan: undefined,
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

/**
 * Parse a keybinding value from `[extension.hunk-review-plan.keybindings]`.
 * Supports a single chord string, an array of chords, or `false` / `""` / `[]`
 * to unbind. Invalid values fall back to the default so bad config never breaks
 * extension startup.
 */
export function parseKeyBinding(
  raw: unknown,
  fallback: KeyBindingValue,
): KeyBindingValue {
  if (raw === undefined) {
    return fallback;
  }
  if (raw === false || raw === null) {
    return undefined;
  }
  if (typeof raw === "string") {
    const trimmed = raw.trim();
    return trimmed.length > 0 ? trimmed : undefined;
  }
  if (Array.isArray(raw)) {
    const chords: string[] = [];
    for (const item of raw) {
      if (typeof item === "string") {
        const trimmed = item.trim();
        if (trimmed.length > 0) {
          chords.push(trimmed);
        }
      }
    }
    if (chords.length === 0) {
      return undefined;
    }
    return chords.length === 1 ? chords[0] : chords;
  }
  return fallback;
}

export function formatPrimaryKey(key: KeyBindingValue): string | null {
  if (typeof key === "string") {
    return key.length > 0 ? key : null;
  }
  if (Array.isArray(key)) {
    return key[0] && key[0].length > 0 ? key[0] : null;
  }
  return null;
}

/** Parse `[extension.hunk-review-plan]` config from `hunk.config`. */
export function parseExtensionConfig(
  raw: Record<string, unknown> | undefined,
): ReviewPlanExtensionConfig {
  const autoOpen = raw?.autoOpen === true;
  const rawKeys = isRecord(raw?.keybindings) ? raw.keybindings : undefined;

  const toggleNotesRaw =
    rawKeys?.toggleNotes !== undefined
      ? rawKeys.toggleNotes
      : rawKeys?.["toggle-notes"];
  const toggleOnlyRaw =
    rawKeys?.toggleOnly !== undefined
      ? rawKeys.toggleOnly
      : rawKeys?.["toggle-only"];
  const clearPlanRaw =
    rawKeys?.clearPlan !== undefined
      ? rawKeys.clearPlan
      : rawKeys?.["clear-plan"];

  return {
    autoOpen,
    keybindings: {
      toggleNotes: parseKeyBinding(
        toggleNotesRaw,
        DEFAULT_KEYBINDINGS.toggleNotes,
      ),
      toggleOnly: parseKeyBinding(
        toggleOnlyRaw,
        DEFAULT_KEYBINDINGS.toggleOnly,
      ),
      clearPlan: parseKeyBinding(clearPlanRaw, DEFAULT_KEYBINDINGS.clearPlan),
    },
  };
}
