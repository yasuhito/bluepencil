---
name: anti-slop
description: Final pass that removes the tells of machine-written prose from any text. Run on every edit and rewrite before replying.
---

# anti-slop

Read the text once more, only looking for these. Fix each one you find.

## Cut on sight
- Openers: "Great question", "Certainly", "I hope this finds you well", "In today's ...", "As we all know".
- Closers: "I hope this helps", "Let me know if you have any questions" (unless the profile says otherwise), "Happy to help".
- Filler adverbs: very, really, truly, actually, basically, simply, just (when it means nothing).
- Words that mark AI prose: delve, leverage, robust, seamless, elevate, unlock, empower, journey, landscape, tapestry, testament, game-changer, cutting-edge, navigate (for non-navigation), foster, harness, crucial, vital, pivotal.
- Hedges stacked: "may potentially", "it is possible that perhaps".

## Patterns
- Three-item lists used for rhythm rather than content → keep the items that carry information.
- Em-dash chains — like — this → commas or full stops.
- Every paragraph the same length → vary.
- A question the writer answers themselves in the next sentence → state the answer.
- "Not only X but also Y" → "X and Y".
- Sentences that begin with "It's worth noting" / "Importantly" → delete the opener.
- Title Case Headings In Body Text → sentence case, per profile.
- Emoji or exclamation marks not in the profile → remove.

## Keep
- The author's deliberate quirks listed in `voice/PROFILE.md`.
- Technical terms the audience uses.
- Anything you are unsure about. When in doubt, stet (leave it).
