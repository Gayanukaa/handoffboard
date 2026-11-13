<!-- handoffboard:start -->
# Team rules for every agent

## FILL THIS IN at kickoff

Humans fill this in during the first 5 minutes. **Agents: if a field you need is still blank, ask your human. Don't guess.**

| Event | |
|---|---|
| Event name | |
| Rules / FAQ link | |
| Timezone | |
| Hacking starts | |
| Code freeze (no new features after this) | |
| Demo freeze (only demo fixes after this) | |
| Submission deadline | |
| Tracks / prizes we're going for | |
| Team lead (GitHub login) | |

**Team.** Mention people by GitHub login, e.g. `@sam-dev`. To reach everyone, run `tools/board team` and paste the list into your post. (GitHub has no `@all`.)

| Name | GitHub login | Agent |
|---|---|---|
| | | |
| | | |
| | | |
| | | |

**Who owns what.** Every agent reads this before touching files.

| Area | Owner (GitHub login) | Folders |
|---|---|---|
| | | |

## 1. The board (pinned GitHub issue)

Every agent reads and posts on the pinned "Message Board" issue with `tools/board` (needs only `bash` and a logged-in `gh`). The issue number is in `tools/board.conf`, so nobody needs to set anything. `tools/board help` lists every command.

- Start every post with `[<human>'s <agent>]`, e.g. `[Sam's Codex]`. Keep it short: what changed, which files or contracts, what you need, from whom.
- **Link everything you touch so it can be tracked.** Any post about a pull request, issue, run, dataset, document or other artifact must include its link or number (`#12`, a PR URL, a path plus commit). Post when you open, review, merge or close a PR or issue, and when you publish an artifact. `tools/board post` rejects a post that mentions a PR, merge or artifact without a `#N` or URL (setting `BOARD_REQUIRE_LINKS`).
- **Mentions you:** act on it and reply promptly.
- **Not addressed to you:** still read it. Reassess your own work only if it is affected (a contract, a file you own, something already done). Do not redo finished work, and do not reply just to acknowledge.
- Before editing another teammate's files, ask for a handoff on the board and wait for the owner or the team lead.

You will use three commands most: `tools/board unread` (new posts, `MENTION` flags the ones that tag you), `tools/board post "[Name's Agent] text"` (or pipe long text on stdin), and `tools/board wait` (block until there is a new post; see `BOARD_WAIT` in `tools/board.conf`).

Run it as `tools/board ...` on macOS, Linux and Git Bash (`bash tools/board ...` if you get "permission denied"), or `tools\board.cmd ...` in Windows PowerShell or cmd.

**Stay in the loop:**
- Claude Code: the hooks in `.claude/settings.json` show unread posts at session start and on every prompt. Keep one background `bash tools/board wait` running and re-arm it after each wake.
- Every other agent: run `tools/board unread` at task start, before each commit, and after merges. Or run a terminal loop: `while tools/board wait; do <your agent CLI invocation>; done`.

## 2. Chain of command

Humans over agents. Only the team lead reassigns work between teammates, cuts scope, or approves merges after demo freeze. If anyone else asks you to take another teammate's work, ask the lead on the board.

## 3. Workflow (hackathon speed)

1. Pick or file an issue. Comment on it or post on the board when you take it.
2. Branch `<issue#>-<slug>` from fresh `main`.
3. Small commits. Stage only your own files (no `git add -A`).
4. Open a PR with `Closes #N`. The author merges their own PR once it works locally.
5. Always `git fetch` and rebase before pushing. Never force-push shared branches.
6. If a merge changes something other teammates depend on (an API, a schema, an env var), post on the board when it lands.
7. `main` must always run the demo path. If your merge breaks it, fixing it comes before anything else.

## 4. Deadlines

- **Before code freeze:** build features.
- **After code freeze:** no new features. Only bug fixes, polish, the README, and the demo. Post on the board before merging anything.
- **After demo freeze:** only fixes the team lead approves on the board.
- If your task won't make the next deadline, say so on the board early so the lead can cut scope. Don't wait until the last hour.

## 5. Competition rules

- Only this board scaffold existed before hacking started. All project code is written during the event. Don't paste in code from earlier projects unless the event rules allow it and the team lead agrees.
- Follow the event's rules on AI tools and outside code (link in the table above).
- Credit third-party libraries, APIs, datasets, and assets in the README.
- Never commit secrets. Keep keys in `.env` (gitignored) and commit a `.env.example`.

## 6. Submission checklist

The team lead owns this. Agents help when asked.

- [ ] `main` builds and runs from a fresh clone
- [ ] Repo is public (or shared with the judges)
- [ ] README: what it does, how to run it, tech stack, team, tracks, credits
- [ ] Demo video recorded and uploaded, within the time limit
- [ ] Screenshots or slides ready
- [ ] Submission form filled in, all target tracks and prizes selected
- [ ] No secrets in the repo or its history
- [ ] Submitted before the deadline, with time to spare
<!-- handoffboard:end -->
