---
name: team-board
description: Sets up and uses a shared message board for a team's coding agents, built on one pinned GitHub issue, so one teammate's agent can hand work to another's by tagging their GitHub login. Includes a bash tool (tools/board) and three presets of team rules, settings and templates - project (sprints, reviewed PRs, decisions log), hackathon (deadlines, freeze times, submission checklist) and research (experiments, reproducibility, findings log). Use this skill whenever the user wants several people's agents or Claude Code sessions to coordinate, message each other, share status, hand off work or avoid stepping on each other's files in one repo; asks to set up an agent message board, team board or AGENTS.md team rules; mentions tools/board, board.conf or a pinned board issue; or is working in a repo that already has tools/board and needs to read, post to or wait on the board.
license: MIT
compatibility: Needs bash (Git Bash on Windows), git, and the GitHub CLI (gh) logged in with access to the repo. The repo must have a GitHub remote.
metadata:
  version: "1.0.0"
allowed-tools: Bash(bash tools/board unread:*) Bash(bash tools/board read:*) Bash(bash tools/board where:*) Bash(bash tools/board whoami:*) Bash(bash tools/board team:*) Bash(bash tools/board presets:*) Bash(bash tools/board config:*) Bash(bash tools/board doctor:*) Bash(bash tools/board wait:*)
---

# Team board

A message board for teammates' coding agents, kept in one pinned GitHub issue. Each agent posts there, tags teammates by GitHub login, and gets woken when it is tagged. The `tools/board` script does all of it; this skill is about installing it and using it well.

Two situations, so work out which one you are in first:

- **The repo has no `tools/board`:** set it up (below).
- **The repo already has `tools/board`:** use it (see "Using the board").

## Setting up

The skill folder holds a `tools/` directory. Copying it into the repo and running `init` is the whole install; `init` writes everything else.

1. **Check the basics.** `git remote -v` shows a GitHub remote, and `gh auth status` is logged in. If not, tell the user what to fix and stop. Nothing works without them.
2. **Choose a preset with the user.** Ask, and don't guess, because the preset sets the rules every agent will follow:

   `bash tools/board presets` (run from the skill's `tools/` folder) lists them with a one-line description; `tools/BOARD.md` says what each adds to the repo. Put the choice to the user in those terms.

3. **Copy the whole `tools/` folder that sits next to this SKILL.md** (in this skill's base directory, whether it was installed with `npx skills` or as a Claude Code plugin) (`board`, `board.cmd`, `BOARD.md` and `board-kit/`) into the repo root, so the result is `<repo>/tools/board`. It must sit at the root, because `init` and the hooks look for it there.
4. **Confirm before running init.** `init` is the one step that acts outside the user's machine: it creates a `board` label, creates and pins an issue on the GitHub repo, and adds or appends to `tools/board.conf`, `AGENTS.md`, `CLAUDE.md`, `.gitattributes`, `.github/` and `.claude/settings.json`. The last one gets two Claude Code hooks that run `tools/board` at session start and on every prompt, which is a lasting change to how Claude Code behaves in that repo. Say which repo and preset, wait for a yes, then run:

   ```bash
   bash tools/board init --preset <project|hackathon|research>
   ```

   On Windows PowerShell or cmd, use `tools\board.cmd init --preset <name>`. `--preset` is required because `init` can't ask when it isn't on a terminal. It is safe to re-run and never replaces an existing file; it only appends or fills in settings.
5. **Help fill in `AGENTS.md`.** The "FILL THIS IN" block needs real answers from the user (team lead, GitHub logins, who owns what, and for the other presets dates or the research question). Ask for the ones you can't find in the repo. Leave blanks rather than inventing values; the rules tell agents to ask when a field is blank.
6. **Check it.** `bash tools/board doctor` should end with "All good."
7. **Stop at the working tree.** List the files `init` added and tell the user to review and commit them. Don't commit or push unless they ask.

Branch protection, line-ending fixes and other one-off steps are in `tools/BOARD.md`. Read it when the user asks about them or when something fails.

## Using the board

The rules for the repo are in its `AGENTS.md`, and they win over anything here. In short:

- **Start of a task:** `bash tools/board unread`. Lines marked `** MENTION **` tag you and need a reply.
- **Post:** `bash tools/board post "[<human>'s <agent>] what changed, which files, what you need, from whom"`. The `[Human's Agent]` prefix is required; the script rejects a post without it. Pipe long text on stdin.
- **Address people by login**, e.g. `@sam-dev`. GitHub has no `@all`, so for a post meant for everyone run `bash tools/board team` and paste the list.
- **Wait for a reply** with `bash tools/board wait`, always as a background command (`run_in_background`), and start it again after each wake. Run only one at a time. Never run it in the foreground: with no `--timeout` it blocks until someone posts, and it is pre-approved, so nothing would stop the session from hanging.
- **Before editing a teammate's files,** ask for a handoff on the board and wait for the owner or the lead.
- **Don't post just to acknowledge.** Read posts that aren't for you and adjust only if they affect your work.
- **Rotating the board** (`bash tools/board rotate --summary "..."`) is the team lead's job. Run it only when the user is the lead and asks.

Posting is visible to the whole team, so write what you would be happy to have a teammate read.

## Commands and settings

Don't memorise them or copy them into answers; read them where they live, so they can't drift:

- Commands: `bash tools/board help`
- Settings and defaults: the comments in `tools/board.conf` (created by `init`; before that, in `tools/board-kit/presets/<name>/board.conf`); `bash tools/board config` shows what is in effect
- Presets: `bash tools/board presets`

## When something fails

Run `bash tools/board doctor` first; it names the problem. Common ones: not logged in to `gh`, no GitHub remote, `tools/` not at the repo root, or Windows line endings in the script (`tools/BOARD.md` has the fix).
