Target: chapters/<id>.tex
Exercises: yes

<!--
Template for one unit spec. Save as chapters-instructions/NN-<id>.md.
  NN    order (sorted numerically; leave gaps, e.g. 10, 11, 12, 20, 21)
  <id>  unit id, also the default target name (chapters/<id>.tex)
Header lines (first 15 lines, all optional):
  Target: <path.tex>   default chapters/<id>.tex; use frontmatter/preface.tex,
                       frontmatter/acknowledgments.tex, backmatter/appendices.tex ...
  Exercises: no        for part intros, introduction, preface, epilogue
  Contents: no         for a chapters/ target that must not be \input
Delete the header lines whose default you want, and delete this comment.
-->

# Unit <id> - <Title>

## Role in the book

<Which section of BOOK_INSTRUCTIONS.md this unit realizes, and where it sits
between the previous and next units.>

## Structure

<Ordered list of sections with what each must do. Mark the opening problem,
the main result, and the return to the opening problem.>

1.  <Section title>: <goal>.
2.  <Section title>: <goal>.

## Required definitions and results

-   <Definition, with the convention to use>.
-   <Theorem/proposition that must be stated and proved>.

## Code

-   <Function/class to implement, signature, and what it demonstrates>.
-   <Earlier artifacts to reuse (by name, see book-plan/ledger.md)>.

## Continuity

-   Builds on: <labels/concepts from earlier units>.
-   Sets up: <what later units will need from this one>.

## Exercises

<Specific exercises that must appear, per level, if any. Otherwise the
writer follows WRITER_INSTRUCTIONS.md.>

## Scope limits

-   <What not to cover, or to keep brief>.

## Completion criteria

-   <Checkable statement>.
-   `scripts/build.sh` prints `BUILD: OK`.
-   `scripts/lint-unit.sh <id>` prints `LINT: OK`.
