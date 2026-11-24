export interface ReviewPlanFileEntry {
  path: string;
  summary?: string;
  note?: string;
}

export interface ReviewPlan {
  version: 1;
  repoRoot: string;
  title?: string;
  only: boolean;
  updatedAt: string;
  files: ReviewPlanFileEntry[];
}

export interface ReviewPlanInputFile {
  path: string;
  summary?: string;
  note?: string;
}

export interface ReviewPlanInput {
  title?: string;
  only?: boolean;
  files: ReviewPlanInputFile[];
}

/** Normalize line endings to LF and trim outer blank lines when requested. */
export function normalizeText(value: string): string {
  return value.replace(/\r\n?/g, "\n");
}

/**
 * Normalize a repository-relative file path so Windows backslashes and leading
 * `./` segments match Git and Hunk diff paths.
 */
export function normalizeFilePath(raw: string): string {
  let normalized = raw.trim().replace(/\\/g, "/");
  normalized = normalized.replace(/\/+/g, "/");
  while (normalized.startsWith("./")) {
    normalized = normalized.slice(2);
  }
  normalized = normalized.replace(/\/+$/, "");
  return normalized;
}

function normalizeOptionalString(
  value: unknown,
  fieldName: string,
  options?: { singleLine?: boolean },
): string | undefined {
  if (value === undefined || value === null) {
    return undefined;
  }
  if (typeof value !== "string") {
    throw new Error(`${fieldName} must be a string`);
  }
  const lf = normalizeText(value);
  const cleaned = options?.singleLine
    ? lf.replace(/\s+/g, " ").trim()
    : lf.trim();
  return cleaned.length > 0 ? cleaned : undefined;
}

/**
 * Validate and normalize an untrusted JSON payload into a ReviewPlan.
 * Duplicate file paths keep their first position while merging newer non-empty
 * summary/note fields if omitted in the earlier entry.
 */
export function parseReviewPlanInput(
  raw: unknown,
  repoRoot: string,
  overrides?: { only?: boolean; title?: string; updatedAt?: string },
): ReviewPlan {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) {
    throw new Error("Plan payload must be a JSON object");
  }
  const obj = raw as Record<string, unknown>;
  if (!Array.isArray(obj.files)) {
    throw new Error("Plan payload must include a 'files' array");
  }

  const title =
    overrides?.title !== undefined
      ? normalizeOptionalString(overrides.title, "title", { singleLine: true })
      : normalizeOptionalString(obj.title, "title", { singleLine: true });

  let only = false;
  if (overrides?.only !== undefined) {
    only = overrides.only;
  } else if (obj.only !== undefined) {
    if (typeof obj.only !== "boolean") {
      throw new Error("only must be a boolean");
    }
    only = obj.only;
  }

  const entries: ReviewPlanFileEntry[] = [];
  const indexByPath = new Map<string, number>();

  for (let i = 0; i < obj.files.length; i++) {
    const item = obj.files[i];
    let rawPath: unknown;
    let rawSummary: unknown;
    let rawNote: unknown;

    if (typeof item === "string") {
      rawPath = item;
    } else if (item && typeof item === "object" && !Array.isArray(item)) {
      const record = item as Record<string, unknown>;
      rawPath = record.path;
      rawSummary = record.summary;
      rawNote = record.note;
    } else {
      throw new Error(`files[${i}] must be a string path or an object`);
    }

    if (typeof rawPath !== "string") {
      throw new Error(`files[${i}].path must be a string`);
    }
    const path = normalizeFilePath(rawPath);
    if (!path) {
      throw new Error(`files[${i}].path must not be empty`);
    }

    const summary = normalizeOptionalString(rawSummary, `files[${i}].summary`, {
      singleLine: true,
    });
    const note = normalizeOptionalString(rawNote, `files[${i}].note`);

    const existingIndex = indexByPath.get(path);
    if (existingIndex !== undefined) {
      const existing = entries[existingIndex]!;
      entries[existingIndex] = {
        path: existing.path,
        ...(existing.summary ?? summary
          ? { summary: existing.summary ?? summary }
          : {}),
        ...(existing.note ?? note ? { note: existing.note ?? note } : {}),
      };
      continue;
    }

    indexByPath.set(path, entries.length);
    entries.push({
      path,
      ...(summary ? { summary } : {}),
      ...(note ? { note } : {}),
    });
  }

  return {
    version: 1,
    repoRoot,
    ...(title ? { title } : {}),
    only,
    updatedAt: overrides?.updatedAt ?? new Date().toISOString(),
    files: entries,
  };
}

/** Validate a stored JSON file on disk, returning null if corrupted or incompatible. */
export function parseStoredReviewPlan(raw: unknown): ReviewPlan | null {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) {
    return null;
  }
  const obj = raw as Record<string, unknown>;
  if (obj.version !== 1 || typeof obj.repoRoot !== "string") {
    return null;
  }
  try {
    return parseReviewPlanInput(obj, obj.repoRoot, {
      updatedAt:
        typeof obj.updatedAt === "string"
          ? obj.updatedAt
          : new Date(0).toISOString(),
    });
  } catch {
    return null;
  }
}
