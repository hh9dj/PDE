import { describe, expect, test } from "bun:test";
import {
  DEFAULT_KEYBINDINGS,
  formatPrimaryKey,
  parseExtensionConfig,
  parseKeyBinding,
} from "../src/config.ts";

describe("parseExtensionConfig", () => {
  test("returns defaults when config is empty or undefined", () => {
    expect(parseExtensionConfig(undefined)).toEqual({
      autoOpen: false,
      keybindings: DEFAULT_KEYBINDINGS,
    });
    expect(parseExtensionConfig({})).toEqual({
      autoOpen: false,
      keybindings: DEFAULT_KEYBINDINGS,
    });
  });

  test("parses autoOpen and camelCase keybinding overrides", () => {
    const cfg = parseExtensionConfig({
      autoOpen: true,
      keybindings: {
        toggleNotes: "ctrl+n",
        toggleOnly: ["alt+o", "ctrl+o"],
        clearPlan: "alt+x",
      },
    });

    expect(cfg).toEqual({
      autoOpen: true,
      keybindings: {
        toggleNotes: "ctrl+n",
        toggleOnly: ["alt+o", "ctrl+o"],
        clearPlan: "alt+x",
      },
    });
  });

  test("accepts kebab-case keybinding names", () => {
    const cfg = parseExtensionConfig({
      keybindings: {
        "toggle-notes": "N",
        "toggle-only": "O",
        "clear-plan": "X",
      },
    });

    expect(cfg.keybindings).toEqual({
      toggleNotes: "N",
      toggleOnly: "O",
      clearPlan: "X",
    });
  });

  test("supports unbinding with false, empty string, or empty array", () => {
    const cfg = parseExtensionConfig({
      keybindings: {
        toggleNotes: false,
        toggleOnly: "",
        clearPlan: [],
      },
    });

    expect(cfg.keybindings).toEqual({
      toggleNotes: undefined,
      toggleOnly: undefined,
      clearPlan: undefined,
    });
  });

  test("collapses single-element arrays and ignores invalid values", () => {
    expect(parseKeyBinding(["  alt+p  ", ""], "alt+n")).toBe("alt+p");
    expect(parseKeyBinding(42, "alt+n")).toBe("alt+n");
    expect(formatPrimaryKey("alt+n")).toBe("alt+n");
    expect(formatPrimaryKey(["ctrl+n", "alt+n"])).toBe("ctrl+n");
    expect(formatPrimaryKey(undefined)).toBeNull();
  });
});
