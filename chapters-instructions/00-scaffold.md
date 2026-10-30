Target: frontmatter/title.tex
Exercises: no

# Unit scaffold - Book Scaffold

This spec is book-agnostic and ships with the template. It is always the
first unit. It prepares the book-specific LaTeX skeleton so that every
later unit only writes prose into an existing file.

You are the only writer allowed to read the headings of every spec in
`chapters-instructions/` and the whole outline of `BOOK_INSTRUCTIONS.md`.
Read only headings and titles, not chapter bodies.

## Inputs

- `BOOK_INSTRUCTIONS.md` (title, subtitle, author, language, notation,
  part and chapter structure).
- `book-plan/plan.tsv` (`scripts/plan.sh list`): unit ids and target files.

## Required work

1. **Language.** If `BOOK_INSTRUCTIONS.md` names a language other than
   English, add the matching `babel` line in the "Encoding, fonts,
   language" block of `preamble.tex` and translate the fixed English
   strings defined there (`Theorem`, `Definition`, `Exercise`, `Level`,
   `Key idea`, `Listing`, `Exercises`, the `\crefname` entries).
2. **Book macros.** Add to the "Book-specific macros" block of
   `preamble.tex` the notation that `BOOK_INSTRUCTIONS.md` fixes globally
   (one macro per line, with a comment). Do not invent notation that the
   instructions leave to individual chapters.
3. **Title page.** Write `frontmatter/title.tex` (title, subtitle, author,
   using `titlepage`) and `frontmatter/copyright.tex` (author, year,
   no fabricated ISBN or publisher). Set `pdftitle` and `pdfauthor` with
   `\hypersetup` at the end of `preamble.tex`.
4. **Stubs.** For every row of the plan except this one, create the target
   file if it does not exist, containing only its heading and label:
   - part introduction units: `\part{<Part title>}\label{part:<key>}`
     followed by an empty line (the writer adds the part's introduction);
   - chapter units: `\chapter{<Chapter title>}\label{chap:<key>}`;
   - unnumbered units (introduction, conclusion, preface,
     acknowledgments): `\chapter*{<Title>}`, plus
     `\addcontentsline{toc}{chapter}{<Title>}` and a label when the unit
     lives in the main matter.
   Choose short, stable `<key>` values (for example the unit id) and list
   every stub label in the ledger under `Labels`.
5. **Back matter.** Leave `backmatter/bibliography.tex` as it is. Create
   `backmatter/appendices.tex` only if `BOOK_INSTRUCTIONS.md` asks for
   appendices that no unit spec covers (heading and label only).
6. **Ledger.** Fill `Book metadata` (title, subtitle, author, language,
   code language, label key of each unit) and `Macros`/`Notation` for
   everything added in steps 1 and 2.

## Constraints

- Do not write any chapter prose.
- Do not change the document class, geometry, `main.tex`, or the
  environments already defined in `preamble.tex`, except for translating
  their fixed strings in step 1.
- Do not edit `chapters/contents.tex`; it is generated.

## Completion criteria

- `scripts/build.sh` prints `BUILD: OK` and the table of contents lists
  every part and chapter of the plan in order.
- `scripts/lint-unit.sh scaffold` prints `LINT: OK`.
- Every target file listed in the plan exists.
- The summary `book-plan/summaries/scaffold.md` lists the stub labels.
