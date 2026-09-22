---
name: rewrite
description: Rebuild machine-sounding, corporate, or off-voice copy in the company voice for its channel; returns the rewritten text plus a change list. Use when a draft came from another agent, reads like AI or boilerplate, or the human says "make this sound like us".
---

# rewrite

The draft is not in anyone's voice yet. Rebuild it in the company's.

## Steps

1. Read `voice/PROFILE.md` and the channel rules in `skills/channel-drafts/SKILL.md`.
2. Extract the facts from the source into a scratch list: every name, number, date, claim, link, ask. This list is the only thing you are allowed to say. Anything the source implies but does not state becomes `[MISSING: ...]`.
3. Write the piece fresh for the channel, in the company voice, from the fact list. Do not paraphrase the source sentence by sentence; that carries its rhythm over.
4. Check the fact list against your text: every item present, nothing added.
5. Run the `anti-slop` skill.
6. Save `drafts/YYYY-MM-DD-<slug>.md` with `## Source`, `## Rewritten`, `## Facts kept`, `## Changes`.
7. Reply:

```
<rewritten text>

---
Changes
1. <what> — <why>
...
Facts: <n> kept, <m> marked MISSING
```

## When another agent sent it

Agents do not read explanations. Put the rewritten text first and keep the change list to the three that matter. If you had to mark anything `[MISSING]`, say so in the first line after the text so the calling agent can fill it before a human sees it.
