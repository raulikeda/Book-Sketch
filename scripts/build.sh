#!/usr/bin/env bash
# Compile the complete book and print a short report.
#
#   scripts/build.sh            BUILD: OK unless LaTeX/BibTeX errors
#   scripts/build.sh --strict   also fail on undefined references/citations
#
# First output line is always "BUILD: OK" or "BUILD: FAILED".
# Output goes to build/ (main.pdf, main.log). Never cat build/main.log;
# grep it instead.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

STRICT=0
[[ "${1:-}" == "--strict" ]] && STRICT=1

OUT="build"
LOG="$OUT/main.log"
mkdir -p "$OUT"

latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error \
  -outdir="$OUT" main.tex > "$OUT/latexmk.out" 2>&1
rc=$?

errors="$(grep -E '^(\./)?[^ :]+\.tex:[0-9]+:|^! ' "$LOG" 2>/dev/null | sort -u | head -n 10)"
undef_refs="$(grep -oE "Reference \`[^']+' on page [0-9]+ undefined" "$LOG" 2>/dev/null \
  | sed -E "s/Reference \`([^']+)'.*/\1/" | sort -u)"
undef_cites="$(grep -oE "Citation \`[^']+' on page [0-9]+ undefined" "$LOG" 2>/dev/null \
  | sed -E "s/Citation \`([^']+)'.*/\1/" | sort -u)"
# BibTeX errors end in "---line N of file X" or "---while reading file X";
# "no \citation commands" is expected before the first citation.
bib_errors="$(grep -hE "^I couldn't open|---(line [0-9]+ of file|while reading file)" \
  "$OUT"/main.blg 2>/dev/null | grep -v 'I found no .citation commands' | head -n 5)"
n_refs=$(grep -c . <<<"$undef_refs" || true)
n_cites=$(grep -c . <<<"$undef_cites" || true)
n_overfull=$(grep -c '^Overfull \\hbox' "$LOG" 2>/dev/null || true)
pages="$(grep -oE 'Output written on [^ ]+ \([0-9]+ pages?' "$LOG" 2>/dev/null | grep -oE '[0-9]+' | tail -n 1)"

status=OK
if [[ $rc -ne 0 && -z "$errors" && -z "$bib_errors" && ! -f "$OUT/main.pdf" ]]; then
  # latexmk failed without a LaTeX error in the log (e.g. missing tool).
  errors="$(tail -n 5 "$OUT/latexmk.out")"
fi
[[ -n "$errors" || -n "$bib_errors" || ! -f "$OUT/main.pdf" ]] && status=FAILED
[[ $STRICT -eq 1 && ( $n_refs -gt 0 || $n_cites -gt 0 ) ]] && status=FAILED

echo "BUILD: $status"
echo "pages: ${pages:-0}  undefined refs: $n_refs  undefined cites: $n_cites  overfull hboxes: $n_overfull"
if [[ -n "$errors" ]]; then
  echo "errors:"; sed 's/^/  /' <<<"$errors"
fi
if [[ -n "$bib_errors" ]]; then
  echo "bibtex:"; sed 's/^/  /' <<<"$bib_errors"
fi
if [[ $n_refs -gt 0 ]]; then
  echo "undefined refs: $(head -n 15 <<<"$undef_refs" | tr '\n' ' ')"
fi
if [[ $n_cites -gt 0 ]]; then
  echo "undefined cites: $(head -n 15 <<<"$undef_cites" | tr '\n' ' ')"
fi

[[ $status == OK ]]
