---
name: learn-from-shipped
description: Turn what actually went out into voice rules. Use when someone pastes the final version of something you edited, tells you what they changed, or says a draft should sound more like them.
---

# learn-from-shipped

Your draft is a guess at the company voice. The version that actually shipped is
the evidence. The gap between them is the lesson, and it arrives the moment
someone pastes the final text. Do not wait for the weekly check.

## When this runs

- Someone pastes the final version of a piece you worked on.
- Someone says what they changed and why, even in one line.
- Someone says "make it sound more like us" without handing over a sample.
- Someone rejects an edit you made and keeps their original wording.

## Process

1. **Find your draft.** Look in `drafts/` for the matching slug. If there is no
   match, treat the pasted text as a new sample and run `voice-profile`
   instead.
2. **Diff by intent, not by character.** List every place the shipped version
   differs from yours. Ignore typo fixes and facts you had marked
   `[MISSING: …]` that they filled in; those are not voice.
3. **Sort the differences.**
   - *Rule* — a choice that would repeat on the next piece. "They put the ask in
     the subject line." "They cut my sign-off."
   - *One-off* — specific to this piece. "They added the conference date."
   Only rules go in the profile.
4. **Propose at most three.** Write each as the profile writes rules: an
   imperative, then the quoted evidence from the shipped text.
5. **Ask before writing.** Never edit `voice/PROFILE.md` without a yes. Show the
   proposed lines, say which existing rule each one changes or contradicts, and
   stop.
6. **On yes, write it.** Add or amend the rule in `voice/PROFILE.md` with the
   quote and the date. Append one line to `shipped/LOG.md`: date, channel, slug.

## What a good proposal looks like

> Two rules from what you shipped, one thing I am leaving alone.
>
> 1. **Put the ask in the subject line.** You changed "Following up" to
>    "15 minutes next week?" This is the second time; rule 2 currently says the
>    subject should name the topic. I would replace it.
> 2. **Sign off with a first name, no title.** You cut "Ken Sato, Head of
>    Sales" down to "Ken." New rule.
>
> Not a rule: you added the pricing table. That was this email's content, not a
> pattern.
>
> Want these in the profile?

## Rules of the job

- Three proposals is the ceiling. If you found eight differences, the profile is
  not the problem; ask which two matter.
- A rule needs evidence you can quote. No quote, no rule.
- When the shipped version contradicts a rule already in the profile, say so
  explicitly. Do not quietly stack a contradiction.
- One shipped piece is weak evidence. Say "first time I have seen this" on a
  single instance, and "second time" when it repeats. The second time is when a
  rule earns its place.
- If they changed something back to how it was before you touched it, that is
  the strongest signal in this skill. Lead with it.
- Never claim a rule was added until you have written the file.
