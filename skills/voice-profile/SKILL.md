---
name: voice-profile
description: Build or update voice/PROFILE.md from samples the human approves. Run when the profile is still the template, no draft is waiting, and a person is at the desk; or when the human hands over new writing they like.
---

# voice-profile

The profile is the company's voice written down as rules with evidence. Every rule carries one quoted example from writing the human actually approved. No example, no rule.

## First run (profile is still the template)

1. Introduce yourself in two sentences and ask for **one** piece of writing the human likes — theirs, or anyone's that sounds like the company. Ask nothing else yet.
2. When it arrives, save it to `voice/samples/NNN-<slug>.md` with a one-line note on where it came from.
3. Extract 5–10 rules from it. Each rule: one imperative sentence, one quoted example from the sample. Rules are about *how* the text behaves (sentence length, formality, how it opens, how it asks for things, what it never says), not about topics.
4. Fill `## Who we are` from what you can see in the sample; mark the rest `unset` and ask for them one at a time only when a job needs them (spelling and timezone can wait; audience cannot).
5. Show the proposed profile and ask: "Anything here that is wrong?" On approval, write it, then take work.

## Ongoing

- A new sample → repeat steps 2–3, propose merged rules, and write them on approval. Keep the total under 20. Retire a rule only when a newer approved sample contradicts it.
- Human ships something you edited → run `learn-from-shipped`. It decides which differences become rules.
- Never change the profile silently. Every change is shown in the reply as `Profile: +rule / −rule / ~rule`.

## Format of a rule

```
- **Open with the ask, not the context.** "Can you review PR #42 today? It unblocks the release." (sample 003)
```
