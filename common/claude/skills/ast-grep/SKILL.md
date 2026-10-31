---
name: ast-grep
description: Structural code search with ast-grep. Use when searching code by AST structure, writing ast-grep rules, or mapping a file or directory (imports, exports, functions, classes, members) before reading full source.
---

# ast-grep

ast-grep matches code by AST structure, not text. Use it for patterns that plain
grep or ripgrep cannot express.

## When to Use

- Find structural patterns, such as async functions without error handling.
- Locate a language construct with specific parameters or context.
- Map a file or directory before reading full source.
- Search for code that text matching cannot describe.

## Search Workflow

1. Clarify the target pattern and language.
2. Write a small example snippet that should match.
3. Write a rule, starting simple.
4. Test the rule against the example.
5. Search the codebase only after the test matches.

Example rule:

```yaml
id: async-with-await
language: javascript
rule:
  kind: function_declaration
  has:
    pattern: await $EXPR
    stopBy: end
```

Test with a rule file:

```bash
ast-grep scan --rule test_rule.yml test_example.js
```

Test inline:

```bash
echo 'async function test() { await fetch(); }' \
  | ast-grep scan --inline-rules 'id: test
language: javascript
rule:
  pattern: await $EXPR' --stdin
```

Search the codebase:

```bash
ast-grep run --pattern 'console.log($ARG)' --lang javascript .
ast-grep scan --rule my_rule.yml /path/to/project
```

## Outline

`ast-grep outline` prints a compact structural map with line numbers: imports,
exports, functions, classes, structs, interfaces, enums, and their members. It
is syntax-only and cheap, so use it before reading source.

```bash
ast-grep outline <file>
ast-grep outline <dir> --items exports
ast-grep outline <file> --match <symbol> --type class --view expanded
```

See `references/outline.md` for flags, views, and examples.

## CLI Quick Reference

```bash
# Pattern search
ast-grep run --pattern 'foo($ARG)' --lang javascript .

# Rule search
ast-grep scan --rule rule.yml /path

# Inline rule
ast-grep scan --inline-rules 'id: x
language: javascript
rule: {pattern: "await $E"}' /path

# Inspect AST and pattern parsing
ast-grep run --pattern '<code>' --lang javascript --debug-query=cst
ast-grep run --pattern '<code>' --lang javascript --debug-query=pattern

# JSON output
ast-grep run --pattern 'foo($ARG)' --lang javascript --json .
```

`--json` emits an array of matches. `range.start.line` is 0-based.
Metavariables are under `metaVariables.single` and `metaVariables.multi`.

## Rules at a Glance

- Atomic: `pattern`, `kind`, `regex`, `nthChild`, `range`.
- Relational: `inside`, `has`, `precedes`, `follows`.
- Composite: `all`, `any`, `not`, `matches`.
- Metavariables: `$VAR` (single named), `$$VAR` (single unnamed), `$$$` (zero
  or more nodes).

See `references/rule_reference.md` for full rule syntax.

## Key Tips

- Always add `stopBy: end` to `inside` and `has` rules.
- Start with `pattern`; add `kind` and relational rules only when needed.
- Escape `$` in inline rules, or use single quotes: `'\$VAR'` vs `$VAR`.
- Zero matches can mean "code absent" or "wrong node shape". Test on a known
  snippet and use `--debug-query=pattern` to tell them apart.
- Qualified paths are whole nodes: `env::var($E)` does not match
  `std::env::var("X")`. Try both forms or use `$$$` to absorb nodes.

## Resources

- `references/rule_reference.md`: full rule syntax, metavariables, and examples.
- `references/outline.md`: `ast-grep outline` usage, flags, and views.
