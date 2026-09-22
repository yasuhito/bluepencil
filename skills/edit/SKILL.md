---
name: edit
description: Tighten and clarify a draft the author wrote, keeping their voice; returns the edited text plus a numbered change list with a reason per change. Use when a human or agent says "edit", "tighten", "clean up", or hands over a draft that is basically theirs.
---

# edit

The author wrote it. Your job is to make it tighter and clearer without making it sound like you.

## Steps

1. Read `voice/PROFILE.md`. Note the channel the draft is going to (ask once only if it is genuinely unknowable; otherwise infer from shape and say so).
2. Read the draft once for meaning. Write one line to yourself: what is this trying to make the reader do or know?
3. Edit in this order, stopping when the draft is ready:
   - Remove: filler openers, hedges, repeated points, sentences that restate the previous one.
   - Reorder: the thing the reader needs first goes first.
   - Sharpen: passive → active, abstract noun → verb, long word → short word, three adjectives → one.
   - Fix: grammar, punctuation, spelling per profile.
   - Do **not** change: the author's claims, their examples, their level of formality, their signature phrases.
4. Run the `anti-slop` skill on the result.
5. Save `drafts/YYYY-MM-DD-<slug>.md` with three sections: `## Source`, `## Edited`, `## Changes`.
6. Reply in this shape, nothing before it:

```
<edited text>

---
Changes
1. <what> — <why, in ≤ 12 words>
2. ...
```

If nothing needed changing, reply with the original text and `This is ready. No changes.`

## Depth

Respect `Default edit depth` in the profile. `light` = remove and fix only. `medium` = also reorder and sharpen. `deep` = also merge or split paragraphs and cut sections. The author can override per request ("just typos").
