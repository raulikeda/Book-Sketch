# book-plan

State of the writing loop. Everything here is produced by scripts or
agents; you normally do not edit it by hand.

| Path | Written by | Purpose |
|---|---|---|
| `plan.tsv` | `scripts/plan.sh init` / `set` | unit order, status, target, spec, exercise rule |
| `ledger.md` | writers (append only) | macros, notation, labels, code artifacts, open promises |
| `summaries/<id>.md` | each writer | continuity record of one unit (max 60 lines) |
| `logs/<id>.log` | `scripts/run-book-loop.sh` | writer transcript (git-ignored) |

## plan.tsv

Tab-separated, one row per spec in `chapters-instructions/`:

```
order  id  status  target  spec  exercises  contents
```

- `status` is one of `todo`, `in_progress`, `done`, `blocked`.
- `scripts/plan.sh init` can be rerun after adding, removing, or renaming
  specs: it keeps the status of ids that still exist.
- To rewrite a unit, `scripts/plan.sh set <id> todo` and rerun the loop.
- To resume after a `blocked` unit, fix the cause (usually the spec), then
  `scripts/plan.sh set <id> todo`.
