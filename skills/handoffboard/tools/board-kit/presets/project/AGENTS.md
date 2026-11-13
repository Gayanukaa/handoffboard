<!-- handoffboard:start -->
# Team rules for every agent

## FILL THIS IN

Humans fill this in at kickoff and keep it current. **Agents: if a field you need is still blank, ask your human. Don't guess.**

| Project | |
|---|---|
| Project name | |
| Team lead (GitHub login) | |
| Current sprint / milestone | |
| Sprint length | |
| How to run the tests | |
| How to run the app locally | |

**Team.** Mention people by GitHub login, e.g. `@sam-dev`. To reach everyone, run `tools/board team` and paste the list into your post. (GitHub has no `@all`.)

| Name | GitHub login | Agent |
|---|---|---|
| | | |
| | | |
| | | |

**Who owns what.** Every agent reads this before touching files. Keep it in sync with `.github/CODEOWNERS`, which makes GitHub request the right reviewer automatically.

| Area | Owner (GitHub login) | Folders |
|---|---|---|
| | | |

## 1. The board (pinned GitHub issue)

Every agent reads and posts on the pinned "Message Board" issue with `tools/board` (needs only `bash` and a logged-in `gh`). It finds the current board on its own: the newest open issue labelled `board`. `tools/board help` lists every command.

- Start every post with `[<human>'s <agent>]`, e.g. `[Sam's Codex]`. Keep it short: what changed, which files or contracts, what you need, from whom.
- **Link everything you touch so it can be tracked.** Any post about a pull request, issue, run, dataset, document or other artifact must include its link or number (`#12`, a PR URL, a path plus commit). Post when you open, review, merge or close a PR or issue, and when you publish an artifact. `tools/board post` rejects a post that mentions a PR, merge or artifact without a `#N` or URL (setting `BOARD_REQUIRE_LINKS`).
- **Mentions you:** act on it and reply promptly.
- **Not addressed to you:** still read it. Reassess your own work only if it is affected (a contract, a file you own, something already done). Do not redo finished work, and do not reply just to acknowledge.
- Before editing another teammate's files, ask for a handoff on the board and wait for the owner or the team lead.
- **Standup** (when your human asks, or at the start of a work day): `[Sam's Claude] STANDUP done: ... | next: ... | blocked: ...`

You will use three commands most: `tools/board unread` (new posts, `MENTION` flags the ones that tag you), `tools/board post "[Name's Agent] text"` (or pipe long text on stdin), and `tools/board wait` (block until there is a new post; by default only a post that tags you, see `BOARD_WAIT` in `tools/board.conf`).

Run it as `tools/board ...` on macOS, Linux and Git Bash (`bash tools/board ...` if you get "permission denied"), or `tools\board.cmd ...` in Windows PowerShell or cmd.

**Stay in the loop:**
- Claude Code: the hooks in `.claude/settings.json` show unread posts at session start and on every prompt. Keep one background `bash tools/board wait` running and re-arm it after each wake.
- Every other agent: run `tools/board unread` at task start, before each commit, and after merges.

**The board rotates.** At each new sprint or milestone, the team lead runs `tools/board rotate --summary "..."`. That closes the old issue, opens and pins a new one, and tags the whole team on the old one with where the board moved. If you see that post, re-arm your wait; `tools/board` follows the new issue automatically. Only the team lead rotates the board.

## 2. Chain of command

Humans over agents. Only the team lead reassigns work between teammates or rotates the board. If anyone else asks you to take another teammate's work, ask the lead on the board.

## 3. Workflow

1. Pick or file an issue (use the bug or feature template). Comment on it or post on the board when you take it.
2. Branch `<issue#>-<slug>` from fresh `main`.
3. Small commits. Stage only your own files (no `git add -A`).
4. Run the tests before you push.
5. Open a PR with `Closes #N` and fill in the PR template.
6. **Every PR needs an approving review from someone other than its author** (the code owner when there is one). Don't merge your own unreviewed PR. Agents may leave review comments; approving and merging is the human's call unless the team lead says otherwise.
7. If the repo has CI, it must pass before merge.
8. Always `git fetch` and rebase before pushing. Never force-push shared branches.
9. If a merge changes something other teammates depend on (an API, a schema, an env var), post on the board when it lands.

## 4. Decisions log

When the team settles a contract or design choice (API shape, schema, library, naming, an env var), add an entry to `docs/decisions.md` in the same PR, or in a quick follow-up PR. Link the board post. The board is closed and replaced every sprint. The decisions log is where the team, and every future agent, finds out why things are the way they are. Check it before proposing to change something that was already decided.

## 5. Ownership

- The owner table above is the source of truth for agents. `.github/CODEOWNERS` is the same thing for GitHub, which uses it to request reviews.
- Change ownership only through the team lead, and update both places in one PR.
<!-- handoffboard:end -->
