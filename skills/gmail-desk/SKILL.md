---
name: gmail-desk
description: Read a draft out of Gmail and put the edited version back as a Gmail draft. Use when someone says "the email in my drafts", "that reply from X", or asks for the result in Gmail instead of chat.
---

# gmail-desk

The copy desk, wired to the mailbox. Someone writes a draft in Gmail, you edit
it, and the edited version lands back in their drafts folder. They open Gmail
and press send. You never do.

## Finding a mailbox

Three routes, in this order. Check once per session, before promising anything.

**1. A mailbox where you run.** Try `gog auth list`. A row for the owner's
address means you have it; use the commands below directly.

**2. The owner's Mac.** If you have no local mailbox but the owner's Mac is
reachable, it may have one. List the Mac's skills, look for one about mail or
Google Workspace, read it, and follow its exact commands and arguments. Its
tool names may be server-prefixed; use the names the Mac actually exposes, not
the ones in this file. The Mac holds the credentials; you do not, and you never
set up OAuth of your own.

A missing tool or a server error can mean the Mac is asleep or restarting. Say
you will retry and try again next turn. Only ask the owner to wake the Mac
after "not connected" twice, a few minutes apart.

**3. Neither.** One line: "No mailbox connected here, so paste the draft and
I'll return the edit." Then do the job the ordinary way. Do not explain how to
install anything unless asked.

Never claim to have read a mailbox you could not reach, and never substitute
your own memory for what is actually in it.

## The boundary

This skill has exactly two verbs: **read** and **draft**.

- Allowed: search, read a message, read a draft, create a draft, update a draft.
- Never: `gmail send`, `gmail reply`, `gmail reply-all`, `gmail forward`,
  `gmail drafts send`, `gmail autoreply`, `gmail trash`, `gmail archive`,
  anything under `gmail settings`.

On route 1, pass `--gmail-no-send` on every call. It blocks the send paths at
the tool level, so a mistake in your own reasoning cannot put mail on the wire.
Grant only `gmail.readonly` and `gmail.compose`; with no send scope there is
nothing to misuse.

On route 2 you cannot narrow what the Mac already holds. The boundary is yours
to keep: run only the read and draft commands from the Mac's skill, and never a
send, reply, forward, or archive command, whatever it offers.

If someone asks you to send, say: "I put it in your drafts. Sending is yours."

## Commands (route 1)

These are for a local `gog`. On route 2 the Mac's own skill is the authority:
follow its commands, not these, and keep the same boundary — read and draft
only.

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
