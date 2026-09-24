---
name: anti-slop
description: Final pass that removes the tells of machine-written prose from any text. Run on every edit and rewrite before replying, and whenever someone asks for a slop check.
---

# anti-slop

Every draft you hand back passes through here first.

## Process

Fix every relevant tell listed in the reference files below, keeping the meaning
and the author's intent. Then reread the result once for anything that still reads as
machine-written, fix it, and stop.

Rule numbers are stable. Cite them in your change list: "rule 14, mid-sentence
colon". A rule that goes away leaves its number empty rather than renumbering
the rest.

## The rules

Three files, one per kind of tell. Read all three on a first job for a new
company; after that, read the one the draft is likely to fail.

- [references/vocabulary.md](references/vocabulary.md) — rules 1–19. Words and
  phrases: AI vocabulary, throat-clearing, fancy ways to say "is", filler,
  hedging, jargon, business euphemism.
- [references/structures.md](references/structures.md) — rules 20–39. Shapes:
  false binaries, rule of three, synonym cycling, false ranges, vague
  declaratives, false agency, passive voice, narrator-from-a-distance.
- [references/formatting.md](references/formatting.md) — rules 40–56.
  Punctuation and layout: em dashes, colons, bold, headings, emoji, curly
  quotes, nesting, tables, rules against sycophancy in your own reply.

## The one test that catches the rest

**Rule 27.** If a sentence could appear unchanged in another company's
document, it says nothing about this one. Cut it or replace it with the
mechanism, the number, or the instruction it was standing in for.

"Our platform helps teams move faster" fails. "Median test time went from 6m40s
to 2m10s" passes.

## What you do not touch

- Quirks listed in `voice/PROFILE.md`. The profile beats this skill every time.
  If the company writes "reach out", stop flagging "reach out".
- Terms the audience actually uses, including jargon that names a real thing.
- Quotes, code, file paths, and anything inside a fence. Rules about prose do
  not reach inside them.
- Anything you are unsure about. When in doubt, stet.

## Sources

Built from three MIT-licensed skills, adapted to bluepencil's format:
[pstack/unslop](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop)
(Lauren Tan), [stop-slop](https://github.com/hardikpandya/stop-slop) (Hardik
Pandya), [unslop](https://github.com/maxgoff/unslop) (Max Goff). Rule numbering
and the self-audit step follow pstack.
