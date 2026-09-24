---
name: channel-drafts
description: Shape rules per destination — email, Slack or chat, web copy, social post, pull request description, support reply, changelog. Consult during every edit or rewrite once the channel is known.
---

# channel-drafts

The voice stays constant. The shape changes with where the text lands. Apply the profile first, then these.

## Email
- Subject line ≤ 8 words, says what the email is for.
- First sentence is the ask or the news. Context after.
- One ask per email. Deadlines as dates, not "soon".
- Sign-off from the profile; default is the sender's first name alone.

## Slack / chat
- No greeting, no sign-off. Start with the point.
- ≤ 4 lines before a line break. Threads for detail.
- Mentions only for people who must act.
- If it is a request, the last line is what you need and by when.

## Direct message
One person, one ask, no audience. Shorter and warmer than a Slack channel post.
- Say who you are in the first line if they do not already know you. One line, no credentials.
- One ask per message. A second ask halves the answer rate.
- Make the ask answerable in one line: a yes, a time, or a link.
- No preamble about why you are reaching out before the ask. The ask is the reason.
- Length: under 60 words for a cold DM, under 30 for someone you work with.
- Never open with flattery about their work as a lead-in to the ask.

## Web / landing page copy
- Headline: what it does for the reader, ≤ 10 words, no product name required.
- Subhead: one concrete proof or number from the source. No invented numbers.
- Body: short paragraphs, scannable, benefits before features.
- One call to action, verb first.

## Social post
- First line stands alone; assume nothing after it is read.
- No hashtags unless the profile lists them. No emoji unless the profile lists them.
- Plain claims only; link for evidence.

## Pull request / commit description
- Title: imperative, ≤ 70 chars, what changes.
- Body: why in one paragraph, then what changed as a short list, then how it was tested.
- No narrative of the author's process. No "this PR".

## Customer support reply
- Acknowledge the specific problem in the first sentence, in the customer's words.
- Answer, then steps if any, numbered.
- Never promise a date or refund the source did not authorize → `[MISSING: authorization]`.
- Close with one line on what happens next.

## Changelog / release note
- Lead with the user-visible change, in the tense the project's past notes use.
- Group: Added / Changed / Fixed. No internal ticket ids unless the profile wants them.
- One line each. Links to docs where they exist in the source.
- Internal refactors that change nothing a user can see do not belong here.
- A release note is a changelog with one paragraph in front of it: what this release is for, in a sentence. Same grouping under it.
