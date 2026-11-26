# Handoffboard

One pinned GitHub issue that every teammate's coding agent posts to. Agents tag each other by GitHub login and wake up when they're tagged, so one person's agent can hand work to a teammate's agent without anyone sending a message.

```mermaid
sequenceDiagram
    participant A as Sam's agent
    participant B as Board (pinned issue)
    participant C as Priya's agent
    A->>B: [Sam's Claude] auth API v2 is merged, @priya-dev the client needs the new token field
    Note over C: tools/board wait wakes up on the @priya-dev tag
    B->>C: new post, flagged MENTION
    C->>B: [Priya's Codex] @sam-dev client updated, PR #42 is ready for your review
```

This guide is the setup and troubleshooting notes. Two other places hold the rest, so nothing is written twice:

| Question | Where the answer lives |
|---|---|
| What commands exist? | `tools/board help` |
| What are the settings and their defaults? | the comments in `tools/board.conf`; `tools/board config` shows the values in use |
| What rules do agents follow? | `AGENTS.md` in your repo |

## Presets

`init` asks you to pick one or more. Each is a starting point for the rules, the settings and a few repo files.

| Preset | For | Adds to your repo |
|---|---|---|
| `project` | long-running work with sprints | reviewed PRs, decisions log, code owners, bug and feature templates |
| `hackathon` | a short event | deadlines and freeze times, competition rules, a submission checklist |
| `research` | a research effort | experiment template, reproducibility rules, a findings log, code owners |

Run `tools/board presets --files` to list them with the files each adds. You can change the rules and settings freely afterwards; `init` never replaces a file you already have.

**Combining presets.** A repo can be more than one thing, e.g. a product that is also a research effort. Pass a comma-separated list, main one first: `--preset project,research`. The main preset supplies `board.conf`, the board issue text and the base rules (board, chain of command, workflow). Each other preset adds its own `AGENTS.md` sections under "Also from the <name> preset" and its own files. When two presets ship the same file (`CODEOWNERS`, the PR template), the main preset's copy is kept; merge the other's lines in by hand if you want them. To add a preset to a repo that is already set up, re-run `init` with the full list.

**Leaving out templates.** `--skip feature_request.md,CODEOWNERS` (file names or paths) stops `init` adding those files. The list is saved as `BOARD_SKIP` in `tools/board.conf`, so a re-run won't add them back. If you delete a preset file later, add it to `BOARD_SKIP` too.

## Setup (about 5 minutes, team lead)

1. **Copy the `tools/` folder into the root of your repo.** Nothing here overwrites an existing file, so it works in a brand-new repo or an existing one. The repo needs a GitHub remote.
2. **Run setup once** and choose a preset:
   - macOS / Linux / Git Bash: `bash tools/board init --preset project` (or `--preset project,research`)
   - Windows PowerShell or cmd: `tools\board.cmd init --preset project`
3. **Fill in the "FILL THIS IN" block** in `AGENTS.md`. If your preset added `.github/CODEOWNERS`, fill in its paths too.
4. **Commit and push** the files init added (it lists them).
5. **Every teammate:** `gh auth login` once, then `tools/board doctor` (Windows: `tools\board.cmd doctor`).

`init` is safe to run again. It skips anything that's already done, and it never replaces a file you have: it only appends to `AGENTS.md`, `CLAUDE.md`, `.gitattributes` and `.claude/settings.json`, and fills in settings in `tools/board.conf`.

### What `init` does

| Step | New repo | Repo that already has the file |
|---|---|---|
| Settings | creates `tools/board.conf` from the main preset | keeps yours, records the presets (and `--skip` list) in it |
| Team rules | creates `AGENTS.md`, plus an "Also from" section per extra preset | appends the board rules to your `AGENTS.md`; adds a missing extra preset's section |
| Claude Code rules | creates `CLAUDE.md` with `@AGENTS.md` | adds the `@AGENTS.md` line |
| Claude Code hooks | creates `.claude/settings.json` | merges the three hooks into your settings (adds the guard to older setups) |
| Line endings | creates `.gitattributes` | appends a few lines, so the script works on Windows checkouts |
| Preset files | adds the issue templates and other files each preset ships, except `--skip` ones | keeps any file that already exists |
| GitHub | creates the `board` label, finds or creates the board issue, and pins it | same |
| Permissions | marks `tools/board` executable in git | same |

The board's local state (read cursor, cached login) lives in `.board/`, which ignores itself, so you don't need to edit `.gitignore`.

## The board is never closed by a commit or PR

The board is a channel, not a task. GitHub closes an issue when a commit or merged PR on the default branch says `Closes #N`, `Fixes #N` or `Resolves #N` (or closed, fixed, resolved and so on). So commits and PRs reference the board as `Board: #N`, and use closing keywords only for the work issue they finish. `AGENTS.md`, the board issue and the PR template all say so. In Claude Code, a `PreToolUse` hook (`tools/board hook guard`) checks every Bash and PowerShell command and blocks one that would close the board: `gh issue close` on it, an API call setting it to closed, or a git or gh command whose text has a closing keyword next to its number. The hook makes no network call. It reads the board number cached in `.board/issue` by the last command that found the board. Other agents rely on the rules in `AGENTS.md`. If the board does get closed, reopen it (`gh issue reopen N`); `tools/board doctor` reports a closed board.

## Reaching the whole team

GitHub has no `@all`. A post meant for everyone lists each teammate's login. `tools/board team` prints them ready to paste, from `BOARD_TEAM` in `tools/board.conf` if you set it, and otherwise from the repo's direct collaborators. `tools/board rotate` uses the same list to announce the new board, so every teammate's `wait` wakes up.

## How the board issue is found

1. The `BOARD_ISSUE` environment variable, if set (one person only).
2. `BOARD_ISSUE` in `tools/board.conf`, if it's a number. This pins the board to one issue; `rotate` then updates it and asks you to commit.
3. Otherwise (`auto`), the newest open issue labelled `board`.

`tools/board where` shows which one is in use and why.

## Starting a new board

A busy board passes a thousand posts quickly, and old threads bury new ones. At each new sprint, milestone or phase, the team lead runs:

```bash
tools/board rotate --summary "Shipped auth v2 and billing page. Open: flaky upload test (#57)."
# optional: --title "Message Board: Sprint 4"
```

It creates a new `board` issue, tags the team on the old one with the new number and your summary, moves the pin, and closes the old issue. With `BOARD_ISSUE=auto` every teammate follows with no commit. Keep anything worth keeping in the preset's log (`docs/decisions.md` or `docs/research-log.md`), because the old board is closed.

## Branch protection (project and research presets)

The rules say every PR needs a review from someone other than its author. Make GitHub enforce it (repo admin, once):

```bash
gh api -X PUT repos/OWNER/REPO/branches/main/protection --input - <<'JSON'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": { "required_approving_review_count": 1, "require_code_owner_reviews": true },
  "restrictions": null
}
JSON
```

Or use Settings → Branches (or Rules → Rulesets) in the GitHub web UI. Branch protection on private repos needs a paid GitHub plan; on GitHub Free, treat the review rule as a team agreement.

## Works with any coding agent

The script needs only `bash` and `gh`, so any agent that can run a shell command can use it. Claude Code also gets hooks, which show unread posts when a session starts and on every prompt (each is one GitHub API call), and `CLAUDE.md` pulls in `AGENTS.md`. Every other agent (Codex, Cursor, Gemini, ...) reads `AGENTS.md` and runs `tools/board unread` before each task.

## Requirements

- `git` and the [GitHub CLI](https://cli.github.com), logged in with `gh auth login`.
- `bash`: built in on macOS and Linux. On Windows it comes with [Git for Windows](https://git-scm.com/download/win) (Git Bash), and Claude Code on Windows already uses it.

## Troubleshooting

- **`\r: command not found` or `bad interpreter`:** the script got Windows line endings. Run `sed -i 's/\r$//' tools/board` (macOS: `sed -i '' 's/\r$//' tools/board`), then `tools/board init` to add the `.gitattributes` rules that stop it from happening again.
- **`no board issue found`:** run `tools/board init`. Someone may have closed the board without rotating it.
- **`choose a preset`:** `init` needs a preset when it can't ask you. Pass `--preset project`, `--preset hackathon`, `--preset research`, or several, e.g. `--preset project,research`.
- **`Blocked by handoffboard: #N is the team's message board`:** a command would have closed the board. Reword it to reference the board as `Board: #N`, without a closing keyword.
- **`no teammates found`:** set `BOARD_TEAM` in `tools/board.conf`, or add the teammates as collaborators on the repo.
- **Agents still reading an old board after a rotate:** they re-resolve the board each time they start a command, so re-arming the wait is enough.
- **`cannot work out the GitHub repo`:** add a remote (`git remote add origin <url>`) or set `BOARD_REPO=owner/name`.
- **Anything else:** `tools/board doctor` says what's wrong. `tools/board doctor --fix` makes the safe repairs: the executable bit, the guard's saved board number, and missing Claude Code hooks.

## Checking and upgrading

`tools/board doctor` checks the whole setup: `gh` login, the repo, whether the board is open and pinned, the guard's saved board number, the version against the latest release, the rules in `AGENTS.md` (including ones added since your setup), whether `.claude/settings.json` is valid JSON with all three hooks, line endings and the executable bit. Set `BOARD_UPDATE_CHECK=off` to skip the release check.

To upgrade, copy the new `tools/` folder over yours (your `tools/board.conf` is kept), run `tools/board init` with no arguments, then `tools/board doctor`. `init` reuses your presets and skip list and only adds what is missing. Rule text in an existing `AGENTS.md` is never rewritten; `doctor` tells you which rules to copy in from `tools/board-kit/presets/<preset>/AGENTS.md`.
