#!/usr/bin/env bash
# Deterministic alternative to the book-master agent: drives the same loop
# from the shell, one fresh `opencode run --agent chapter-writer` per unit.
#
#   scripts/run-book-loop.sh [--model provider/model] [--max N] [--no-commit]
#
# Writer transcripts go to book-plan/logs/<id>.log.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MODEL=()
MAX=0
COMMIT=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --model) MODEL=(--model "$2"); shift 2 ;;
    --max) MAX="$2"; shift 2 ;;
    --no-commit) COMMIT=0; shift ;;
    *) echo "unknown option $1" >&2; exit 2 ;;
  esac
done

mkdir -p book-plan/logs
[[ -f book-plan/plan.tsv ]] || scripts/plan.sh init

verify() { # <id> -> prints failing lines, returns non-zero on failure
  local id="$1" out fail=0
  out="$(scripts/build.sh)"; head -n 1 <<<"$out" | grep -q 'BUILD: OK' || { head -n 8 <<<"$out"; fail=1; }
  out="$(scripts/lint-unit.sh "$id")" || { head -n 8 <<<"$out"; fail=1; }
  grep -q 'STATUS: DONE' "book-plan/logs/$id.log" || { echo "writer report lacks STATUS: DONE"; fail=1; }
  return $fail
}

run_writer() { # <id> <prompt>
  opencode run --agent chapter-writer --auto "${MODEL[@]}" --title "unit $1" "$2" \
    > "book-plan/logs/$1.log" 2>&1
}

count=0
while id="$(scripts/plan.sh next)"; [[ -n "$id" ]]; do
  if [[ "$(scripts/plan.sh get "$id" status)" == blocked ]]; then
    echo "unit $id is blocked; stopping"; break
  fi
  [[ $MAX -gt 0 && $count -ge $MAX ]] && { echo "reached --max $MAX"; break; }
  count=$((count + 1))

  echo "== $id"
  scripts/plan.sh set "$id" in_progress > /dev/null
  prompt="$(scripts/plan.sh prompt "$id")"
  run_writer "$id" "$prompt"

  if ! failures="$(verify "$id")"; then
    echo "   retry: $(head -n 1 <<<"$failures")"
    run_writer "$id" "$prompt

RETRY: the previous attempt failed these checks; fix them.
$failures"
    if ! failures="$(verify "$id")"; then
      scripts/plan.sh set "$id" blocked > /dev/null
      echo "   blocked:"; sed 's/^/     /' <<<"$failures"
      break
    fi
  fi

  scripts/plan.sh set "$id" done > /dev/null
  echo "   done"
  if [[ $COMMIT -eq 1 ]]; then
    git add -A && git commit -q -m "Write unit $id" && echo "   committed"
  fi
done

if [[ -z "$(scripts/plan.sh next)" ]]; then
  echo "== all units done; strict build:"
  scripts/build.sh --strict | head -n 3
fi
scripts/plan.sh list
echo "NOTES from writer reports:"
grep -h '^NOTES:' book-plan/logs/*.log 2>/dev/null | sed 's/^/  /'
