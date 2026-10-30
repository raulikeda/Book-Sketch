#!/usr/bin/env bash
# Check one unit's .tex file for mechanical rule violations.
#
#   scripts/lint-unit.sh <unit-id>                 target and exercise rule from plan.tsv
#   scripts/lint-unit.sh <file.tex> [--no-exercises]
#
# First output line is "LINT: OK" or "LINT: FAILED", followed by findings.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

arg="${1:-}"
[[ -n "$arg" ]] || { echo "usage: lint-unit.sh <unit-id | file.tex> [--no-exercises]" >&2; exit 2; }

exercises=yes
if [[ -f "$arg" ]]; then
  file="$arg"
else
  file="$(scripts/plan.sh get "$arg" target)" || exit 2
  exercises="$(scripts/plan.sh get "$arg" exercises)"
fi
[[ "${2:-}" == "--no-exercises" ]] && exercises=no

findings=()
add() { findings+=("$1"); }

if [[ ! -s "$file" ]]; then
  echo "LINT: FAILED"
  echo "  $file: missing or empty"
  exit 1
fi

# Text with LaTeX comments removed (keeps \%), for content checks.
body="$(sed -E 's/(^|[^\\])%.*$/\1/' "$file")"

hits() { # <regex> <message>
  local out
  out="$(grep -nE "$1" <<<"$body" | head -n 5 | cut -c1-90)"
  [[ -n "$out" ]] && while IFS= read -r l; do add "$2: line ${l}"; done <<<"$out"
}

hits '\b(TODO|FIXME|TBD|XXX)\b|[Pp]laceholder|[Ll]orem ipsum' 'placeholder text'
hits '\\cite[a-z]*\{[^}]*\?[^}]*\}|\\cite[a-z]*\{\}' 'citation placeholder'
hits '(^|[^-])---([^-]|$)|—' 'em dash'
hits '\\(usepackage|documentclass|RequirePackage)\b' 'package/class loaded in a unit (use preamble.tex)'
hits '\\begin\{(minted|lstlisting|verbatim)\}' 'non-standard code mechanism (use pythoncode)'
[[ "$file" == chapters/* ]] && hits '\\(newpage|clearpage|pagebreak|vspace\*?|bigskip|medskip|smallskip)\b' 'manual layout command'

# Duplicate labels across the whole book.
mine="$(grep -oE '\\label\{[^}]+\}' <<<"$body" | sort | uniq)"
dups_local="$(grep -oE '\\label\{[^}]+\}' <<<"$body" | sort | uniq -d)"
[[ -n "$dups_local" ]] && add "duplicate label in file: $(tr '\n' ' ' <<<"$dups_local")"
if [[ -n "$mine" ]]; then
  others="$(grep -rhoE '\\label\{[^}]+\}' chapters frontmatter backmatter --include='*.tex' 2>/dev/null \
    | sort | uniq -c | awk '$1>1 {print $2}')"
  for l in $mine; do
    grep -qxF "$l" <<<"$others" && add "label also defined in another file: $l"
  done
fi

# Citation keys must exist in references.bib.
keys="$(grep -oE '\\cite[a-zA-Z]*(\[[^]]*\])*\{[^}]+\}' <<<"$body" | sed -E 's/.*\{([^}]+)\}/\1/' | tr ',' '\n' | tr -d ' ' | sort -u)"
for k in $keys; do
  grep -qE "@[a-zA-Z]+\{[[:space:]]*${k}[[:space:]]*," references.bib 2>/dev/null || add "citation key not in references.bib: $k"
done

# Exercises: three difficulty levels and at least three exercises.
if [[ "$exercises" == yes ]]; then
  for n in 1 2 3; do
    grep -qE "\\\\exerciselevel\{$n\}" <<<"$body" || add "missing \\exerciselevel{$n}"
  done
  n_ex=$(grep -cE '\\begin\{exercise\}' <<<"$body" || true)
  [[ $n_ex -ge 3 ]] || add "only $n_ex exercise(s)"
fi

if ((${#findings[@]})); then
  echo "LINT: FAILED"
  printf '  %s\n' "${findings[@]}"
  exit 1
fi
echo "LINT: OK"
