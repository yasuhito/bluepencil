# Shapes and sentences (rules 20–39)

Adapted from the MIT-licensed [pstack/unslop](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop)
(Lauren Tan), [stop-slop](https://github.com/hardikpandya/stop-slop) (Hardik
Pandya), and [unslop](https://github.com/maxgoff/unslop) (Max Goff).

Vocabulary tells are easy to catch. These are the ones that survive a
find-and-replace, and they are what makes a page read as machine-written even
after every banned word is gone.

## 20. False binary

"It's not X, it's Y." "Not only X, but also Y." "This isn't about X. It's about
Y." The contrast is invented to make Y sound bigger. State Y.

## 21. Rule of three

Three adjectives, three examples, three clauses, because three has a rhythm.
Use the number the content has. Two often beats three. One is allowed.

## 22. Question the writer answers

"So what does this mean for your team? It means fewer handoffs." Delete the
question. Keep the answer.

## 23. Meta-joiners

"The rest of this post will cover", "Before we get into that", "As mentioned
above", "In this section we'll". The document moves without narrating itself.

## 24. Performative closings

A final "Summary", "Conclusion", or "Key takeaways" heading that repeats what
was already said. Stop at the last fact.

## 25. Dramatic one-liners

A short punchy sentence on its own line to land a point: "And that changes
everything." "That's the whole game." If it reads like a pull-quote, cut it.

## 26. Uniform paragraph rhythm

Every paragraph three sentences. Every sentence the same length. Three
consecutive sentences of matching length is the detectable pattern; break one.

## 27. Says what it feels, not what it does

**The single most useful test in this file.**

"the database stays close at hand", "SQL you can read", "tools that grow with
your team" name a feeling. Replace with the mechanism, a number, or the
instruction:

- "Our platform helps teams move faster" → "Median test time went from 6m40s to
  2m10s."
- "a seamless onboarding experience" → "Four fields, no credit card, and you're
  in."

Two checks:

1. Ask what the sentence tells the reader to do or know, then write that. If you
   cannot restate it as a concrete instruction, fact, or number, cut it.
2. If the sentence could appear unchanged in another company's document, it says
   nothing about this one. Cut it.

## 28. Vague declaratives

"The implications are significant." "The reasons are structural." "There are
several factors at play." Name the implication, the reason, the factor.

## 29. False agency

An inanimate thing doing a human action: "the complaint becomes a fix", "the
decision emerges", "the data tells us", "the roadmap decides". Name the person
or team who acted.

## 30. Passive voice

"Queries are validated" → "the compiler validates queries". "The file is parsed
by the loader" → "the loader parses the file". Catch "is/are/was/were + past
participle" and name the actor. Passive is fine when the actor is genuinely
unknown or irrelevant, and in the rare case where the company voice calls for
distance.

## 31. Narrator from a distance

"Nobody designed this." "People often struggle with." "One might wonder."
Put the reader in the scene: "you" beats "people", the specific beats the
general.

## 32. Dense sentences

If the reader has to go back to parse it, split it or drop a clause. One idea
per sentence. This rule and rule 26 pull against each other on purpose: vary
length, but never at the cost of a sentence nobody can read once.

## 33. Over-compression

Dropped articles, verbless fragments, arrows, and abbreviations that make the
reader decode instead of read. "Parser rejects bad date → exit 2, no write"
becomes "The parser rejects a bad date, exits with code 2, and writes nothing."

## 34. Mannered prose

Metaphor where a literal phrase exists. Aphorisms ("ship it or kill it"),
rhetorical fragments for effect, personified code ("the plan holds it"),
figurative verbs ("rides along", "stands on"). "A dial worth turning" becomes "a
parameter worth varying". Rule 11 covers the metaphor nouns; this is the same
problem at sentence level.

## 35. Wh- openers

A sentence starting with "What", "Which", "When", "Why", "How" as a rhetorical
setup rather than a real question. Restructure it.

## 36. Escalating triads

"faster, cheaper, and more reliable" where each item is doing less work than
the last. Keep the one with evidence behind it.

## 37. Apology and self-narration

In a reply: apologizing more than once, cataloguing past mistakes, narrating
self-criticism. Correct the error and continue. In a draft: hedged apology that
never says what went wrong. Name what broke, in one line.

## 38. Unearned enthusiasm

Exclamation marks, "we're thrilled", "we're excited to announce", "we can't
wait". Unless the profile says the company writes this way, the news is the
news. Deleting the emotion usually strengthens it.

## 39. Sycophancy toward the reader

"Great question." "You're absolutely right." "Smart approach." Answer instead.
This rule binds bluepencil's own replies as much as the drafts it edits.
