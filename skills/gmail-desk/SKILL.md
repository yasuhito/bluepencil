---
name: gmail-desk
description: Read a draft out of Gmail and put the edited version back as a Gmail draft. Use when someone says "the email in my drafts", "that reply from X", or asks for the result in Gmail instead of chat.
---

# gmail-desk

The copy desk, wired to the mailbox. Someone writes a draft in Gmail, you edit
it, and the edited version lands back in their drafts folder. They open Gmail
and press send. You never do.

Optional. If `gog` is not installed or no account is authorized, say so in one
line and ask for the text pasted into chat instead.

## The boundary

This skill has exactly two verbs: **read** and **draft**.

- Allowed: search, read a message, read a draft, create a draft, update a draft.
- Never: `gmail send`, `gmail reply`, `gmail reply-all`, `gmail forward`,
  `gmail drafts send`, `gmail autoreply`, `gmail trash`, `gmail archive`,
  anything under `gmail settings`.

Pass `--gmail-no-send` on every call. It blocks the send paths at the tool
level, so a mistake in your own reasoning cannot put mail on the wire. The
OAuth grant is `gmail.readonly` plus `gmail.compose`; there is no send scope to
use even if you tried.

If someone asks you to send, say: "I put it in your drafts. Sending is yours."

## Commands

Set the account once per job; `$ACCOUNT` below is the address the owner named.

Find the draft:

```
gog gmail drafts list --account $ACCOUNT --gmail-no-send --max 10
gog gmail search 'from:someone@example.com newer_than:7d' --account $ACCOUNT --gmail-no-send --max 10
```

Read it:

```
gog gmail drafts get <draftId> --account $ACCOUNT --gmail-no-send
gog gmail get <messageId> --account $ACCOUNT --gmail-no-send
```

Put the edit back. Update the same draft when you were given a draft; create a
new one when you were given a received message to reply to:

```
gog gmail drafts update <draftId> --account $ACCOUNT --gmail-no-send \
  --to "<recipients>" --subject "<subject>" --body-file -
gog gmail drafts create --account $ACCOUNT --gmail-no-send \
  --to "<recipients>" --subject "<subject>" --body-file -
```

Pass the body on stdin with `--body-file -`. Do not inline a multi-line body
into the command.

## Process

1. **Find one draft.** If the owner named it, use that. If the search returns
   several and you cannot tell which, list the candidates by subject and sender,
   ask which one, and end the turn.
2. **Read it, and read what it replies to** when the draft is a reply. The
   thread carries facts the draft leans on.
3. **Edit or rewrite** per the usual rules, `anti-slop` included, in the email
   shape from `channel-drafts`.
4. **Write it back** as a draft. Keep the recipients and subject the owner
   already set unless the edit changes the subject; say so if it does.
5. **Reply in chat** with the finished text, the change list, and the draft id.
   The owner should be able to judge it without opening Gmail.
6. **Save to `drafts/`** like any other job.

## Rules of this desk

- A `[MISSING: …]` marker goes into the Gmail draft exactly as it is. Never
  quietly fill a gap to make the draft look sendable; the visible gap is what
  stops a bad send.
- Never touch a draft the owner did not point you at.
- One draft per job. Editing five at once hides what changed.
- Read only what the job needs. You have the whole mailbox; use the narrowest
  search that finds the one thing.
- Quote nothing from other messages into your chat reply beyond what the edit
  required.
- Report the draft id in your reply. That is the receipt.
