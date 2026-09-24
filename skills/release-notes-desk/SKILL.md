---
name: release-notes-desk
description: Turn what actually shipped — merged pull requests and closed issues — into release notes a customer can read. Use when someone says "write the release notes", "what went out this week", or points at a version and asks what to tell people.
---

# release-notes-desk

The work is done and recorded. Somebody still has to tell the people who use
the thing what changed for them. That translation is the job: from what the
team did to what the reader can now do.

## Finding the work

Try `gh auth status`. Logged in means you have it. Otherwise one line — "I'm
not connected to GitHub here, so paste the merged titles and I'll write from
those" — and do the job from what they give you. If the owner's Mac holds a
GitHub skill, follow that skill's commands instead; the Mac keeps the
credentials.

## The boundary

**Read in, chat out.** You return the notes in the conversation. You do not run
`gh release create`, `gh release edit`, or push a CHANGELOG commit. A release
is an announcement; a person decides when it goes out.

## Commands

Read only.

```
gh release list --limit 5
gh pr list --state merged --limit 30 --json number,title,mergedAt,labels
gh pr list --state merged --search "merged:>=<YYYY-MM-DD>" --json number,title,body
gh issue list --state closed --limit 30 --json number,title,closedAt,labels
gh pr view <number> --json title,body
git log --oneline --since="<YYYY-MM-DD>" --first-parent
```

Replace `<YYYY-MM-DD>` with the start date of the chosen range before running either command.

Two ways to bound the range, and you must pick one and say which: since the
last release tag, or a date range the owner gave you. Never mix them. No tags
at all is common; then the version boundary comes from the manifest
(`package.json`, `Cargo.toml`, a gemspec), and you say which.

**Pull requests are not the whole record.** Plenty of work lands straight on
the default branch, and a repository where that is normal will lose most of a
release if you only read merged PRs. Run the `git log` line too, compare the
counts, and if the direct commits carry real changes, include them and say in
one line that you did. When commit messages are bare one-liners, the honest
source of what changed is the diff of the docs and spec files, not the
messages.

## The translation

Each line answers one question: **what can the reader do now that they could
not do before?** A merged title answers what the team did, which is a
different sentence.

Example (write the notes in the language of the last release, not the PR title):

- `fix(export): 高桁量子ビットラベル・長い測定名・ダーク不透過 PNG の回路レンダリングを修正`
- → Circuit exports no longer clip long qubit labels or measurement names, and dark-mode PNGs are opaque.

**Read the last release first.** Wherever this project's notes live — GitHub
releases, `CHANGELOG.md`, a `docs/releases/` directory — the existing ones
decide your headings, their language, their order, and any section the project
always includes. Match them. The house style wins over the defaults below,
every time; a release note that does not look like the last one reads as
written by an outsider.

Rules for the list:

- **Group by what it means to the reader**: Added, Changed, Fixed, in this
  project's own words. Not by author, not by merge order, not by component.
- **One line each.** A change that needs a paragraph gets its own short
  section above the list.
- **Merge the duplicates.** Four PRs fixing one export bug are one line. Say
  the bug, not the four commits.
- **A number beats an adjective.** "Faster" is nothing; "41s to 12s" is
  something. Only if the source says it — never estimate a speedup.
- **Name the thing the reader names it.** Their word for the feature, not the
  internal module name.
- **Link the PR number** when the repository's own notes do. Match the house
  style; look at the last release before deciding.

## What does not go in

- Dependency bumps, lockfile updates, formatter migrations, CI changes, and
  internal refactors. Nobody outside installs a different autoprefixer.
- Anything you cannot state as a user-visible difference.

If that leaves nothing, say so in one line: "Everything since the last release
is dependencies and build tooling — there are no user-visible changes to
announce." Do not manufacture a release. A release note for a week with no
user-facing work is worse than no release note: it teaches readers to skip
them.

## Shape

An optional one-sentence lead, only when something genuinely leads the
release. Then Added / Changed / Fixed, dropping any section that is empty.

No "We're excited to announce", no "This release brings", no thanking the
community for their patience, no adjectives about the release itself. The
reader decides whether it is exciting.

If something breaks compatibility, that goes first, under **Breaking**, with
what to do about it. A breaking change buried under Changed is a support ticket.

## Process

1. **Fix the range.** Last tag, the manifest version, or the dates the owner
   named. State it in your reply.
2. **Pull the merged PRs, the closed issues, and the direct commits** in that
   range, then read the last release note in this project to learn its shape.
3. **Drop the invisible ones** per the list above. Say how many you dropped
   and why, in one line, so the owner can push back.
4. **Translate what is left**, one line per user-visible change, grouped.
5. **Run `anti-slop`** over the result like any other draft.
6. **Return the notes in chat**, then the change list, then anything you were
   unsure how to translate — a title you could not turn into a user-visible
   sentence is a `[MISSING: what changed for the reader in #NNN?]`, not a
   guess.
7. **Save to `drafts/`** like any other job.
