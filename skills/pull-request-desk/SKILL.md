---
name: pull-request-desk
description: Read a pull request and hand back an edited title and body. Use when someone points at a PR instead of pasting text ("clean up the description on #42", "this PR reads like a changelog").
---

# pull-request-desk

A pull request description is writing that leaves your company. Reviewers read
it, the merge commit keeps it, and six months later it is the only explanation
of why the change exists. It deserves the desk.

## Finding the repository

Try `gh auth status`. Logged in means you have it. Not logged in, or no `gh`
at all: one line — "I'm not connected to GitHub here, so paste the title and
body and I'll edit them" — then do the job the ordinary way.

If the owner's Mac is reachable and holds a GitHub skill, follow that skill's
own commands and tool names instead. The Mac keeps the credentials; you never
authenticate on your own.

## The boundary

**Read in, chat out.** You read the PR and return the edit in the conversation.
You do not run `gh pr edit`, comment, review, approve, merge, or close. A PR
body is a notification to every reviewer watching the repository; the person
who owns the change decides when it changes.

If asked to apply it: "Here's the edit. Paste it into the PR — I don't write to
your repository."

## Commands

Read only. Every one of these is safe; nothing below changes anything.

```
gh pr view <number> --json title,body,headRefName,baseRefName
gh pr diff <number> --name-only
gh pr diff <number> --patch
```

Without a number, `gh pr view` reads the PR for the current branch.

## The one thing this desk checks that no other does

**Does the description match the diff?**

Read `--name-only` at minimum. A description that claims something the changed
files cannot support is the most common failure in a PR, and it is invisible if
you only read the prose. Three shapes to catch:

- **Claims not in the diff.** "Also adds retry logic" with no retry in the
  changed files. That is a `[MISSING: …]` or a cut, never a smoothing-over.
- **Changes not in the description.** A migration, a dependency bump, or a
  config change the body never mentions. Say so: "The diff also touches
  `schema.sql` — worth a line?"
- **A body that is a changelog.** A list of every commit tells a reviewer
  nothing about why. Rebuild it: what was wrong, what this does, what a reviewer
  should look at hardest.

Say which of these you checked. If the diff was too large to read, say that
instead of implying you read it.

## Shape

**Title.** The change, not the area. "Fix bug" and "Update auth" are not
titles. Present tense, no ticket number unless the repository does it that way
— look at a few recent PRs before deciding.

**Body**, in this order:

1. What was wrong, or what was missing. One or two sentences.
2. What this change does about it.
3. What a reviewer should look at hardest, if anything.
4. How it was verified — tests, manual steps, a screenshot. Only what the source
   says; never invent a test run.

Cut: restating the diff line by line, "this PR", "in this commit", thanks,
apologies, and any sentence that would be true of any PR in any repository.

## Process

1. **Resolve the PR.** A number, a URL, or the current branch. If the owner
   named nothing and the branch has no PR, ask which one and end the turn.
2. **Read the title, body, and at least the file list.**
3. **Edit or rewrite** per the usual rules, `anti-slop` included.
4. **Return the title and body in chat**, ready to paste, then the change list,
   then the diff mismatches you found.
5. **Save to `drafts/`** like any other job.
