# WRITER_INSTRUCTIONS.md

# General Writing Instructions

## Mission

Write a technically rigorous computer science book that is practical,
direct, and conceptually distinctive.

The manuscript must not read like a generic textbook assembled from
standard definitions. Each chapter should have a clear intellectual
purpose and should contribute to the book's central argument. The reader
should understand not only how a concept is defined, but why the
abstraction was needed, what problem it solves, and where its limits
are.

The target reader is a computer science student or practicing programmer
who is comfortable reading code but should not be assumed to have
advanced mathematical maturity.

Maintain rigor. Do not replace precise definitions with analogies. Use
intuition to motivate a formal idea, then state the idea accurately.

## LaTeX and Repository Template

The book must be written in **LaTeX**, using the existing LaTeX template and project structure found in the working directory.

Treat the repository template as authoritative. Before writing or restructuring content:

- inspect the existing directory structure;
- identify the main LaTeX entry point and included chapter files;
- inspect the document class, packages, macros, environments, bibliography setup, code-listing configuration, and build process;
- reuse existing commands and environments instead of recreating equivalent ones;
- preserve the template's typography, page layout, front matter, chapter organization, cross-reference conventions, and bibliography style;
- place new files in the locations expected by the template;
- follow the existing naming and inclusion conventions;
- ensure the project continues to compile with its existing build workflow.

Do not replace the template, introduce a new document class, or redesign the LaTeX project unless explicitly instructed.

Write mathematical notation natively in LaTeX. Use the template's existing environments for definitions, examples, theorems, proofs, exercises, code, figures, and callouts when available.

For Python code, use the code-listing mechanism already configured by the template. Do not introduce `minted`, `listings`, or another package if the project already defines a code environment.

Use `\label`, `\ref`, `\eqref`, citations, bibliography commands, glossary commands, and index commands according to the conventions already present in the repository.

Prefer semantic LaTeX over manual visual formatting. Do not use spacing commands, font-size changes, manual page breaks, or ad hoc formatting to repair layout unless the template already uses them for that purpose.

Each generated chapter must be valid LaTeX and should compile as part of the complete book, not merely as an isolated text fragment.

## Core Pedagogical Pattern

Whenever the subject permits, build a chapter in the following
direction:

1.  Start with a concrete problem, program, puzzle, system, or
    real-world computational situation.
2.  Let the reader encounter a limitation, ambiguity, repeated pattern,
    or unanswered question.
3.  Introduce the mathematical or computational abstraction because it
    is needed to solve or explain that problem.
4.  Develop the theory incrementally.
5.  Return to the opening problem and solve, explain, classify, or
    reinterpret it using the new theory.
6.  Generalize the result and explain why it matters beyond the original
    example.

Do not begin a chapter with several pages of definitions unless there is
a compelling reason. Prefer discovery before formalization.

The practical opening must be intellectually relevant. Do not invent
superficial stories merely to make an abstract topic look practical.

## Computational Examples

Use Python only when makes sense and whenever computation can illuminate the mathematical idea. Do not force its use.

Python examples should be small enough to understand completely. Prefer
transparent implementations over libraries that hide the concept being
taught.

Use code to:

-   construct examples;
-   implement abstract machines;
-   explore mathematical structures;
-   test conjectures;
-   generate counterexamples;
-   demonstrate algorithms;
-   expose limitations;
-   compare alternative definitions;
-   turn mathematical objects into executable objects.

Code is part of the argument, not decoration.

When a concept cannot be represented faithfully in ordinary Python, say
so. Use pseudocode or another notation when it makes the mathematics
clearer. Do not distort a concept merely to force it into Python.

Code should normally be executable and should use modern Python. Avoid
unnecessary frameworks, dependencies, metaprogramming, or clever
language tricks.

## Mathematical Rigor

Use precise definitions before relying on a term technically.

Clearly distinguish:

-   definition from theorem;
-   theorem from conjecture;
-   proof from intuition;
-   syntax from semantics;
-   mathematical equivalence from analogy;
-   existence from construction;
-   finite examples from general results;
-   established results from philosophical interpretation.

Proofs should match the goals of the book. Give full proofs when the
argument is central and accessible. Use proof sketches when the
technical details would obscure the computational idea. Never claim that
an example proves a general result.

When a result depends on assumptions, state them.

Counterexamples should be used aggressively when they clarify why a
tempting statement is false.

## Technical Voice

Write in clear technical English.

The prose should be:

-   direct;
-   precise;
-   compact;
-   explanatory without being conversationally loose;
-   suitable for an undergraduate computer science textbook;
-   confident without overstating claims.

Avoid prose that sounds like an essay, blog post, motivational speech,
or AI-generated overview.

Do not repeatedly tell the reader that something is fascinating,
elegant, powerful, important, or surprising. Demonstrate its
significance through the material.

Avoid filler such as:

-   "It is worth noting that"
-   "As we can clearly see"
-   "Needless to say"
-   "In today's world"
-   "Let us embark on"
-   "This fascinating concept"
-   "At its core"
-   "In essence"

Use first-person plural sparingly. Prefer direct statements such as
"Consider the following program" over "Let us consider the following
program."

Vary sentence length. A run of sentences with the same length and
structure reads as mechanical. Mix short statements with longer
explanatory sentences, and do not open consecutive sentences with the
same word or construction.

Avoid vocabulary that signals generic or machine-generated prose, such
as:

-   delve
-   tapestry
-   realm
-   pivotal
-   landscape
-   leverage

Words such as *robust* or *comprehensive* are acceptable only when they
carry a precise technical meaning that the text states or that the
field has established.

Avoid formulaic contrast constructions of the form "it is not X, it is
Y" when no reader would have assumed X.

## Punctuation and Typography

Do not use em dashes.

Avoid excessive use of colons. Prefer complete sentences when a colon is
not structurally necessary.

Avoid excessive use of double quotation marks. Use technical notation,
italics, code formatting, or direct prose instead when appropriate.

Do not use decorative Unicode symbols when ordinary text or mathematical
notation is clearer.

Do not overuse parenthetical remarks.

Keep headings informative and concise.

## Definitions, Theorems, and Examples

Definitions should be motivated before or immediately after they are
introduced.

A useful sequence is often:

**Problem -\> Example -\> Observation -\> Definition -\> Consequence -\>
Generalization**

Use formal blocks consistently when the manuscript format supports them:

-   Definition
-   Example
-   Counterexample
-   Proposition
-   Theorem
-   Proof
-   Remark

Do not create a theorem-like block for ordinary commentary.

Examples should do real conceptual work. Prefer one example developed
carefully over several nearly identical examples.

Whenever possible, reuse an example later under a stronger abstraction.
This helps the reader see why the theory is cumulative.

## Chapter Structure

Unless the subject strongly suggests another organization, each chapter
should contain:

### Opening problem

A concrete problem or computational situation that motivates the
chapter.

### Development

Build the required concepts incrementally. Alternate explanation,
formalization, and computation rather than placing all theory first and
all code later.

### Main result

Identify the chapter's central conceptual or mathematical result.

### Return to the opening problem

Use the developed theory to resolve or reinterpret the problem
introduced at the beginning.

### Broader consequences

Explain what the result enables, what it cannot do, and how it connects
to later chapters.

### Summary

End with a concise technical summary. Do not merely repeat section
headings.

### Exercises

Every substantive chapter must end with exercises grouped by difficulty.

Use three levels:

#### Level 1 - Foundations

Check definitions, basic constructions, traces, calculations, and direct
applications.

#### Level 2 - Application and Reasoning

Require the reader to combine ideas, write or modify code, construct
examples, find counterexamples, or justify conclusions.

#### Level 3 - Challenge

Require deeper reasoning, proofs, nontrivial implementations,
extensions, comparisons, or open-ended investigation with a well-defined
technical goal.

Include computational exercises whenever appropriate. Some exercises
should require Python implementation, but not every mathematical
exercise should be converted into a programming task.

Do not provide solutions in the chapter body.

## Continuity Across Chapters

Treat the book as one argument, not a collection of independent
articles.

Reuse notation consistently.

When a concept returns, connect it explicitly to its earlier use rather
than redefining it from scratch.

Do not repeatedly preview the entire book.

Avoid forward references unless they help explain why a limitation is
being left unresolved.

Each chapter should create a reason for the next chapter to exist.

## Originality and Positioning

The manuscript must not become another standard book on the subject with
Python examples added afterward.

Its distinctive contribution must remain visible in chapter design.

The practical and computational viewpoint should determine:

-   the order in which concepts are introduced;
-   which formal details receive emphasis;
-   which examples are selected;
-   which proofs are included;
-   how abstractions are motivated;
-   how chapters connect.

Do not imitate the chapter structure, wording, example sequence, or
pedagogical framing of an existing textbook.

Use standard terminology and established mathematics, but construct an
original exposition.

## Source Discipline

Verify historical claims, theorem statements, attribution, and
nontrivial technical facts against reliable sources during research.

Do not copy source wording.

Do not fabricate quotations, historical anecdotes, citations, theorem
names, or references.

Do not attribute claims to unnamed authorities, as in "some believe" or
"many argue". Name the source and cite it, or remove the claim.

Verify that every library, package, function, contract interface,
compiler version, and tool named in the text or used in code exists
with the stated name, signature, and behavior in the stated version. Do
not rely on remembered APIs, since they change between releases.

When there are multiple conventions in the literature, choose one, state
it, and use it consistently.

## Final Quality Check for Every Chapter

Before considering a chapter complete, verify that:

-   the chapter has a specific purpose;
-   the opening example genuinely motivates the theory;
-   terminology is defined precisely;
-   code supports the argument;
-   notation is consistent;
-   important claims are justified;
-   examples do not substitute for proofs;
-   the chapter returns to its opening problem when appropriate;
-   the connection to the book's central thesis is visible;
-   exercises exist at all three difficulty levels;
-   em dashes are absent;
-   colons and double quotation marks are not overused;
-   the prose is technical and direct;
-   sentence length and structure vary;
-   claims are not attributed to unnamed authorities;
-   every named library, function, and version has been verified;
-   the chapter does not read like a generic survey of the topic.
