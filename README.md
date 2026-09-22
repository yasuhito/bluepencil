# bluepencil

![bluepencil — the copy desk for everything that leaves your company](assets/bluepencil-hero.png)

**The editor every piece of writing in your company passes through before it goes out.**

bluepencil is an [OpenClaw](https://openclaw.ai) agent that owns one job: the copy desk. Humans paste drafts to it. Your other agents send it theirs. It hands back ship-ready text in your company's voice, with every change listed and explained. It never publishes anything — you do.

Not a censor. A blue pencil shows its marks.

## What it does

- **Edit** — you wrote it; it gets tighter and clearer and still sounds like you.
- **Rewrite** — an agent wrote it, or it reads like boilerplate; it gets rebuilt in the company voice for the channel it is going to.
- **Anti-slop pass** on everything: the tells of machine prose come out.
- **Channel shapes** for email, Slack, web copy, social, pull requests, support replies, changelogs.
- **One voice, on disk.** `voice/PROFILE.md` holds your company's voice as rules with quoted evidence. Every human and every agent that writes gets the same editor.

## What it never does

- Invent a fact, name, number, price, date, quote, or customer. Gaps stay visible as `[MISSING: …]`.
- Send, post, push, or reply on your behalf.
- Change what you meant.

## Multiplayer by design

bluepencil is built for OpenClaw 2.0's shared sessions:

- **People** join one shared *editing desk* session. Give teammates *Suggest* or *Draft* rights and the workflow enforces itself: bluepencil drafts, a human ships.
- **Agents** call it with `sessions_send` and get the finished text back in the same turn. Put it in front of your SDR agent's emails, your recruiter agent's candidate replies, your engineer agent's PR descriptions.

Every draft it touches is saved with source, result, and change list side by side, so you can always see what was changed and why.

## Install

You need an OpenClaw Gateway (2026.9 or later).

```bash
git clone https://github.com/yasuhito/bluepencil ~/bluepencil
```

Register it as an agent (JSON5, in `~/.openclaw/openclaw.json` under `agents.entries`):

```json5
bluepencil: {
  workspace: "~/bluepencil",
  identity: { name: "bluepencil", emoji: "✏️" },
  model: { primary: "anthropic/claude-opus-5" },   // any strong writing model works
}
```

Allow your other agents to call it (`tools.agentToAgent.allow`), open a shared session for the team, and paste one piece of writing you like. bluepencil builds the voice profile from it and starts taking work.

## Calling it from another agent

```
sessions_send(agentId: "bluepencil", message: "Rewrite for email:\n\n<draft>")
```

The reply is the finished text first, then a short change list. If bluepencil had to mark anything `[MISSING]`, it says so on the first line after the text.

## Put it in Slack

The desk works best where the writing already happens. In Slack, anyone on the team types `/bluepencil <draft>` in the channel they are already in and the edit comes back in that channel, where the rest of the team can see it.

Five steps, all of which have to be done — missing any one of them fails with a different, unhelpful message.

**1. The Slack app.** [api.slack.com/apps/new](https://api.slack.com/apps/new) → **From a manifest**. Paste [`docs/slack-manifest.json`](docs/slack-manifest.json), then **Create**. It uses Socket Mode, so your Gateway needs no public URL.

**2. Two tokens.** **Basic Information** → **App-Level Tokens** → generate one with the `connections:write` scope; that is the `xapp-` token. Then **OAuth & Permissions** → **Install to Workspace**; that gives you the `xoxb-` token. Store both without putting them in your shell history:

```bash
openclaw secrets store set SLACK_APP_TOKEN --kind secret --value-file - \
  --allow-host slack.com --allow-host api.slack.com
openclaw secrets store set SLACK_BOT_TOKEN --kind secret --value-file - \
  --allow-host slack.com --allow-host api.slack.com
```

Each waits on stdin: paste the token, press enter, then Ctrl-D.

**3. Point Slack at bluepencil.** `bindings` is a whole-array replacement, so include the routes you already have alongside the new one.

```json5
{
  channels: {
    slack: {
      enabled: true,
      mode: "socket",
      appToken: { source: "store", provider: "default", id: "SLACK_APP_TOKEN" },
      botToken: { source: "store", provider: "default", id: "SLACK_BOT_TOKEN" },
      groupPolicy: "open",            // any channel it is invited to
      allowFrom: ["U0123ABCDEF"],     // who may use the slash command
      slashCommand: { enabled: true, name: "bluepencil", ephemeral: false },
    },
  },
  bindings: [
    // ...your existing bindings...
    { agentId: "bluepencil", match: { channel: "slack" } },
  ],
}
```

`ephemeral: false` posts the edit into the channel. Set it to `true` if the edit should be visible only to whoever asked.

**4. Approve yourself for DMs.** Message the bot once. It replies with a pairing code; run what it tells you:

```bash
openclaw pairing approve slack <code>
```

**5. Restart-free, but not instant.** Slack config changes wait for in-flight work to finish before the channel reloads. Give it a few seconds before the first test.

Two gates, not one: pairing covers DMs, `allowFrom` covers the slash command. Approving one does not approve the other, and each refuses with its own message — "access not configured" for DMs, "You are not authorized to use this command" for the command. Your Slack user id is in the DM refusal, or under your profile in Slack.

## Connections

Optional. bluepencil works fine with text pasted into a session; connections just remove the copy-paste.

OpenClaw speaks MCP, so anything you already write in can feed the desk: a docs workspace, a chat channel, an issue tracker. Add the server to your `openclaw.json` and bluepencil reads drafts from it. Reading is all most of them need to do.

The mailbox is the one connection that writes, and it writes only to your drafts folder. It is optional: without it, bluepencil says so and takes the draft pasted into chat.

It finds a mailbox two ways. Where bluepencil runs on your own machine, that is a local `gog`:

```bash
gog auth credentials set ~/Downloads/client_secret_*.json
gog auth add you@example.com --remote --step 1 \
  --services gmail --gmail-scope readonly \
  --extra-scopes https://www.googleapis.com/auth/gmail.compose
```

Two scopes: read your mail, and create drafts. No send scope, so bluepencil cannot put mail on the wire even by mistake. Every call it makes adds `--gmail-no-send`, which blocks the send paths at the tool level too.

Where bluepencil runs in a container and you have connected your Mac, it borrows the Mac's mailbox instead: it lists the skills your Mac publishes, reads the one about mail, and follows that skill's own commands. Your Mac keeps the credentials. See `skills/gmail-desk/SKILL.md` for both routes and the boundary that holds in each.

The loop: you write a rough draft in Gmail, bluepencil edits it and saves the result back to drafts, you open Gmail and press send. A `[MISSING: …]` marker travels into the draft unchanged — the visible gap is what stops a bad send.

## Layout

```
AGENTS.md            operating instructions
SOUL.md              how it thinks
IDENTITY.md          name, role, look
skills/              edit · rewrite · anti-slop · channel-drafts
                     voice-profile · learn-from-shipped · gmail-desk
voice/PROFILE.md     your company voice (rules + quoted evidence)
voice/samples/       writing you approved
drafts/              every job: source, result, changes
shipped/LOG.md       what actually went out
```

## License

MIT. See `LICENSE`.
