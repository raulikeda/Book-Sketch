# Book-Sketch

A book-agnostic template for writing a technical computer science book in
LaTeX with a multi-agent loop in [opencode](https://opencode.ai). One
writer agent writes one unit (chapter, part introduction, preface...) per
session; a coordinator dispatches the units in order, verifies the build,
and commits.

Nothing in this repository refers to a specific book. To start a book,
mirror this repository and add the book-specific files listed below.

## What you need to produce

Only two things are book-specific:

| You write | Where | Template |
|---|---|---|
| The global spec of the book: title, author, language, mission, reader, narrative architecture, notation, one section per part and chapter, global constraints | `BOOK_INSTRUCTIONS.md` (repository root) | `templates/BOOK_INSTRUCTIONS.template.md` |
| One spec per unit, named `NN-<id>.md`; `NN` gives the order, `<id>` the unit id | `chapters-instructions/` | `templates/unit-spec.template.md` |

Everything else (preamble, plan, stubs, summaries, ledger, chapters) is
produced by the scripts and the agents.

### Unit specs

```
chapters-instructions/
  00-scaffold.md      shipped with the template, keep it as the first unit
  05-preface.md       Target: frontmatter/preface.tex   Exercises: no
  08-intro.md         Exercises: no
  10-p1-intro.md      Exercises: no        (contains \part{...})
  11-p1-ch1.md
  12-p1-ch2.md
  20-p2-intro.md      Exercises: no
  21-p2-ch3.md
  ...
  90-conclusion.md    Exercises: no
```

- The order is the numeric order of `NN`; leave gaps so you can insert units.
- The id is the file name without `NN-`; the default target is
  `chapters/<id>.tex`.
- Optional header lines at the start of a spec, each at the beginning of
  a line:
  - `Target: <path.tex>` for units outside `chapters/` (preface,
    acknowledgments, dedication, epigraph, appendices, colophon);
  - `Exercises: no` for units without exercises (part intros, introduction,
    preface, conclusion);
  - `Contents: no` for a `chapters/` file that must not be included.
- Main-matter targets are included in plan order through the generated
  `chapters/contents.tex`. Front and back matter are included by `main.tex`
  from fixed paths when the file exists: `frontmatter/{title,copyright,
  dedication,epigraph,preface,acknowledgments}.tex` and
  `backmatter/{appendices,bibliography,colophon}.tex`.
- A part starts with the `\part{...}` written by its part-introduction unit
  (the scaffold creates it as a stub).
- Order of precedence when instructions disagree: unit spec,
  `BOOK_INSTRUCTIONS.md`, `WRITER_INSTRUCTIONS.md`.

### Checklist before dispatching

1. `BOOK_INSTRUCTIONS.md` exists and has one `##` heading per chapter whose
   title matches the corresponding unit spec.
2. `chapters-instructions/` holds `00-scaffold.md` plus your unit specs.
3. `scripts/plan.sh init && scripts/plan.sh list` shows every unit in the
   right order with the right target and exercise rule.
4. `scripts/build.sh` prints `BUILD: OK` (the empty skeleton compiles).
5. The repository is a git repository with a clean working tree (the loop
   commits after every unit).

### Prompt to generate the book materials

Paste the prompt below into an LLM conversation that already holds every
idea for the book: notes, outlines, drafts, reading lists, earlier
discussions. It works best inside this repository (for example in an
opencode session), where the model can read the templates and write the
files directly. In a plain chat, it returns the files as text blocks for
you to save.

````text
You are preparing the planning materials for a technical computer science
book that a multi-agent pipeline will write in LaTeX, one unit (chapter,
part introduction, preface...) per agent session. Every idea the book needs
is already in this conversation. Use only those ideas. Where they leave a
gap, make the smallest reasonable decision and list it under "Decisions
made" in your final message. Never invent facts, citations, quotations, or
historical claims.

If you can read the repository, read these first and follow them exactly:
README.md, WRITER_INSTRUCTIONS.md, templates/BOOK_INSTRUCTIONS.template.md,
templates/unit-spec.template.md, chapters-instructions/00-scaffold.md,
preamble.tex. WRITER_INSTRUCTIONS.md already holds the style and pedagogy
rules shared by every book. Do not repeat them and do not contradict them.
Only add rules that are specific to this book.

Produce:

1. BOOK_INSTRUCTIONS.md, the global spec of the book, with these sections:
   - "# <Title>", "## Working Subtitle", and "## Metadata" (author,
     language, code language);
   - "## Book Mission": the central question or thesis, what the book is
     not, and what the reader can do at the end;
   - "## Target Reader": what to assume and what not to assume;
   - "## Narrative Architecture": the parts, the question each part asks,
     the climax of each part, and pacing constraints;
   - "## Notation and Conventions": notation fixed for the whole book, and
     the convention chosen wherever the literature disagrees;
   - one "# Part N - <Title>" heading per part. Under it, one
     "## Chapter N - <Title>" heading per chapter, with the subsections
     "### Purpose", "### Opening direction", "### Required content",
     "### Pedagogical constraint" (optional), "### Computational work"
     (optional), and "### Chapter outcome";
   - sections for the introduction, the epilogue or conclusion, and the
     preface, if the book has them;
   - "## Global Book Constraints": scope limits, recurring artifacts that
     later chapters must reuse, and the progression that must be preserved.
   Writers read only the global sections and their own unit's section, so
   each unit's section must make sense on its own.

2. One unit spec per unit, saved as chapters-instructions/NN-<id>.md:
   - NN gives the order. Use 05 for the preface, 08 for the introduction,
     10, 20, 30... for part introductions, the following numbers for that
     part's chapters (11, 12, ...), and 90 for the conclusion. 00 is
     reserved for the shipped scaffold unit; do not produce it.
   - <id> is short, lowercase, and stable (p1-intro, p1-ch1, intro,
     preface, conclusion). The chapter file is chapters/<id>.tex.
   - The header lines go at the very start of the file, each at the
     beginning of a line: "Target: frontmatter/preface.tex" (or another
     path) for units outside chapters/, and "Exercises: no" for part
     introductions, the introduction, the preface, and the conclusion.
     Omit a header line when its default applies.
   - Follow the unit-spec template: "Role in the book", "Structure"
     (ordered sections, marking the opening problem, the main result, and
     the return to the opening problem), "Required definitions and
     results", "Code" (functions and classes with signatures, plus earlier
     artifacts to reuse, by name), "Continuity" (what it builds on, what it
     sets up), "Exercises" (specific exercises that must appear, if any),
     "Scope limits", and "Completion criteria" (checkable statements that
     end with the build and lint checks).
   - A part-introduction spec must say that the unit opens with
     \part{<Part title>} and stays short.
   - Its title and number must match its heading in BOOK_INSTRUCTIONS.md.

Consistency requirements:
- Every concept is introduced in exactly one unit. Later units name the
  unit they build on.
- Every code artifact has one owner unit, with the same name and signature
  in every spec that mentions it.
- Every unit gives the next unit a reason to exist. Promises made in one
  spec are kept in a named later spec.
- Required content fits one chapter of a typical textbook. Split or trim
  units that are too large.

Output format:
- With repository access, write the files and then print the output of
  `scripts/plan.sh init && scripts/plan.sh list`.
- Otherwise, output each file as a fenced block preceded by its path on a
  line of its own, in plan order, starting with BOOK_INSTRUCTIONS.md.
- End with a short final message containing: the unit table (NN, id,
  title, exercises yes/no), "Decisions made", and "Open questions for the
  author" (only questions whose answers would change the plan).
````

After saving the files, review them yourself before running the checklist
above. The specs drive everything the writers do.

## Running the loop

Two equivalent coordinators. Both stop at the first unit that fails twice
and mark it `blocked`.

**Agent coordinator** (`.opencode/agents/book-master.md`):

```sh
opencode run --agent book-master "Run the book loop."
# or interactively: opencode, then switch to the book-master agent
```

**Shell coordinator** (no LLM in the loop; one fresh opencode session per
unit, transcripts in `book-plan/logs/`):

```sh
scripts/run-book-loop.sh                    # all remaining units
scripts/run-book-loop.sh --max 1            # one unit, then stop
scripts/run-book-loop.sh --model provider/model --no-commit
```

To redo a unit: `scripts/plan.sh set <id> todo`, then run the loop again.

## Repository layout

```
AGENTS.md                    rules every agent reads (opencode loads it automatically)
WRITER_INSTRUCTIONS.md       style and pedagogy rules shared by every book
BOOK_INSTRUCTIONS.md         <- you write it
chapters-instructions/       <- you write NN-<id>.md (plus the shipped 00-scaffold.md)
templates/                   templates for the two files above
main.tex                     entry point; never edited by agents
preamble.tex                 packages, environments, code listings, book macros
references.bib               BibTeX database (natbib, plainnat)
frontmatter/ backmatter/     optional front/back matter files
chapters/                    unit .tex files and the generated contents.tex
book-plan/                   plan.tsv, ledger.md, summaries/ (see book-plan/README.md)
scripts/plan.sh              init | list | next | get | set | prompt
scripts/build.sh             full build, prints BUILD: OK|FAILED  (--strict for refs)
scripts/lint-unit.sh         per-unit checks, prints LINT: OK|FAILED
scripts/run-book-loop.sh     shell coordinator
.opencode/agents/            book-master (coordinator) and chapter-writer (one unit)
```

## How a unit is written

1. The coordinator takes `scripts/plan.sh next`, marks it `in_progress`,
   and sends `scripts/plan.sh prompt <id>` to a fresh `chapter-writer`.
2. The writer reads `WRITER_INSTRUCTIONS.md`, the global sections and its
   own section of `BOOK_INSTRUCTIONS.md`, its spec, `preamble.tex`, the
   ledger, and the summaries of earlier units. It never reads whole earlier
   chapters.
3. It writes the target file section by section, runs `scripts/build.sh`
   and `scripts/lint-unit.sh <id>`, then writes
   `book-plan/summaries/<id>.md` and appends to `book-plan/ledger.md`.
4. The coordinator re-runs both checks, marks the unit `done`, and commits.
   After the last unit it runs `scripts/build.sh --strict`.

The first unit, `scaffold`, sets the language, the global macros, the title
page, and creates a stub (heading and label) for every other unit, so
cross-references resolve early and the table of contents is complete from
the start.

## Requirements

- TeX Live with `latexmk`, `pdflatex`, `bibtex`, and the packages loaded in
  `preamble.tex` (listings, tcolorbox, tikz, cleveref, natbib, ...).
- `python3` (writers run their code examples).
- opencode with a configured model provider.

## Lint rules

`scripts/lint-unit.sh` fails on: TODO/FIXME/TBD/placeholder text, citation
placeholders, em dashes, `\usepackage` in a unit, `minted`/`lstlisting`/
`verbatim` instead of `pythoncode`, manual page/space commands in
`chapters/`, labels defined twice in the book, citation keys missing from
`references.bib`, and (when exercises are required) missing
`\exerciselevel{1..3}` or fewer than three exercises.
