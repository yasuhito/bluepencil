# Punctuation and layout (rules 40–56)

Adapted from the MIT-licensed [pstack/unslop](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop)
(Lauren Tan), [stop-slop](https://github.com/hardikpandya/stop-slop) (Hardik
Pandya), and [unslop](https://github.com/maxgoff/unslop) (Max Goff).

None of these reach inside code, fenced blocks, file paths, or verbatim quotes.

## 40. Em dashes

No em dash in prose. End the sentence, or use a comma. Do not swap in an en
dash, parentheses, or a spaced hyphen; those are the same habit wearing a
different coat.

## 41. Dash-driven afterthoughts

"— and that's the point", "— which is exactly the problem". The clause goes or
becomes its own sentence.

## 42. Mid-sentence colons

Colons are for lists and examples. Not as connectors: "If you're new to this:
start with the defaults" adds nothing. Rewrite so the point stands without the
crutch.

## 43. Rhetorical colons

"The answer: X." "One problem: Y." Write the complete sentence.

## 44. Curly quotes and typographic strays

Straight quotes. Watch for smart quotes, ellipsis characters, and non-breaking
spaces pasted in from a doc.

## 45. Bold overuse

Bold is emphasis, not decoration. More than roughly one line in five bolded and
the emphasis means nothing. Never bold a whole sentence. Do not bold every
proper noun or acronym.

## 46. Inline-header lists

The tell is a bold label plus colon that restates the line: "**Performance:**
Performance improved by 20%." Convert to prose.

Not a tell: a bold lead-in that names the item and is followed by genuinely new
detail. "**Schema in TypeScript.** Tables live in one file." is fine. Reference
material whose items are lookup keys, like this file, is also fine.

## 47. Title Case Headings

Sentence case, unless the profile says otherwise.

## 48. Header inflation

A three-paragraph answer does not need headers. A header earns its place when a
reader needs to skip to a section.

## 49. Nesting

Two levels of bullets. Three deep means the structure is wrong: flatten it or
write prose.

## 50. Tables

Use a table when there are real columns to compare. Do not force a two-column
table onto a list of items with descriptions.

## 51. Decorative rules and separators

Horizontal rules divide genuinely distinct sections, not consecutive
paragraphs.

## 52. Emoji

None in prose, headings, bullets, or commit messages, unless the profile uses
them or the channel convention already does.

## 53. Exclamation marks

One per document is usually one too many. See rule 38.

## 54. Fencing

Code blocks get a language tag. Do not fence ordinary sentences, single file
paths, or lone identifiers; use inline backticks for those.

## 55. Claim versus verification

In your own replies: say what you actually did. "I read the profile and applied
rules 2 and 27" or "I did not check the issue tracker". Never describe
unverified work as done. If a fact in the draft is unconfirmed, it is a
`[MISSING: …]`, not a confident sentence.

## 56. Failure reported straight

If something could not be done, say which part and why, in one line. No
padding, no second apology, no list of what else you tried. See rule 37.
