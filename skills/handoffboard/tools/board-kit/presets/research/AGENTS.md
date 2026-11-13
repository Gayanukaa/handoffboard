<!-- handoffboard:start -->
# Team rules for every agent

## FILL THIS IN

Humans fill this in at kickoff and keep it current. **Agents: if a field you need is still blank, ask your human. Don't guess.**

| Study | |
|---|---|
| Study name | |
| Research question | |
| Lead researcher (GitHub login) | |
| Current phase (e.g. pilot, main runs, writing) | |
| Target venue and deadline | |
| Where the data lives and who can access it | |
| One command that reproduces a result | |
| Compute environment (machine, GPU, cluster, versions) | |

**Team.** Mention people by GitHub login, e.g. `@sam-dev`. To reach everyone, run `tools/board team` and paste the list into your post. (GitHub has no `@all`.)

| Name | GitHub login | Agent |
|---|---|---|
| | | |
| | | |
| | | |

**Who owns what.** Every agent reads this before touching files. Keep it in sync with `.github/CODEOWNERS`.

| Area | Owner (GitHub login) | Folders |
|---|---|---|
| Data and preprocessing | | |
| Experiments and code | | |
| Analysis and figures | | |
| Writing | | |
| References | | |

## 1. The board (pinned GitHub issue)

Every agent reads and posts on the pinned "Message Board" issue with `tools/board` (needs only `bash` and a logged-in `gh`). It finds the current board on its own: the newest open issue labelled `board`. `tools/board help` lists every command.

- Start every post with `[<human>'s <agent>]`, e.g. `[Sam's Claude]`. Keep it short: what ran or changed, where the output is, what you need, from whom.
- **Link everything you touch so it can be tracked.** Any post about a pull request, issue, run, dataset, document or other artifact must include its link or number (`#12`, a PR URL, a path plus commit). Post when you open, review, merge or close a PR or issue, and when you publish an artifact. `tools/board post` rejects a post that mentions a PR, merge or artifact without a `#N` or URL (setting `BOARD_REQUIRE_LINKS`).
- **Mentions you:** act on it and reply promptly.
- **Not addressed to you:** still read it. Reassess your own work only if it is affected (a dataset, a metric, a result you build on). Do not redo finished work, and do not reply just to acknowledge.
- Before touching another teammate's data, code or draft, ask for a handoff on the board and wait for the owner or the lead.
- Post when a result lands, when a run fails in a way that matters, and when you change a dataset, metric or evaluation protocol. Others may be building on it.
- **Standup** (when your human asks, or at the start of a work day): `[Sam's Claude] STANDUP done: ... | next: ... | blocked: ...`

You will use three commands most: `tools/board unread` (new posts, `MENTION` flags the ones that tag you), `tools/board post "[Name's Agent] text"` (or pipe long text on stdin), and `tools/board wait` (block until there is a new post; by default only a post that tags you, see `BOARD_WAIT` in `tools/board.conf`).

Run it as `tools/board ...` on macOS, Linux and Git Bash (`bash tools/board ...` if you get "permission denied"), or `tools\board.cmd ...` in Windows PowerShell or cmd.

**Stay in the loop:**
- Claude Code: the hooks in `.claude/settings.json` show unread posts at session start and on every prompt. Keep one background `bash tools/board wait` running and re-arm it after each wake.
- Every other agent: run `tools/board unread` at task start, before each commit, and after merges.

**The board rotates.** At each new phase, the lead runs `tools/board rotate --summary "..."`. That closes the old issue, opens and pins a new one, and tags the whole team on the old one with where the board moved. If you see that post, re-arm your wait. Only the lead rotates the board.

## 2. Chain of command

Humans over agents. Only the lead reassigns work, changes the research question or protocol, or rotates the board. If anyone else asks you to change these, ask the lead on the board.

## 3. Workflow

1. File an issue for each experiment with the experiment template: hypothesis, setup, metric, done when. Comment on it or post on the board when you take it.
2. Branch `<issue#>-<slug>` from fresh `main`.
3. Small commits. Stage only your own files (no `git add -A`).
4. Open a PR with `Closes #N` and fill in the PR template.
5. **Every PR needs an approving review from someone other than its author.** Agents may leave review comments; approving and merging is the human's call unless the lead says otherwise.
6. Always `git fetch` and rebase before pushing. Never force-push shared branches.

## 4. Reproducibility

- **Raw data is read-only.** Never edit or overwrite it. Write derived data to a new path and keep the code that produced it.
- **Every result must be reproducible.** Fix random seeds. Commit the config or command that produced the result. Record the commit hash, library versions and data version next to the output.
- **Results are never overwritten.** A new run gets a new, dated output path.
- **Large files stay out of git** (data, checkpoints, logs). Commit a pointer instead: path, size, checksum, how to fetch it.
- **No secrets and no personal or participant data** in the repo or its history.

## 5. Findings log

Every claim the team might state in a paper, talk or README gets an entry in `docs/research-log.md`: the claim, the evidence (a path and a commit), and its status (supported, refuted, or inconclusive). Log negative and inconclusive results too, because they stop the next person repeating the run. Never write a claim in the draft that has no entry. If a result changes, add a new entry that replaces the old one, and don't edit the old one.

## 6. Research integrity

- Report what the data shows. Don't tune a metric, split or threshold after seeing the results without logging that you did.
- Say so on the board when you deviate from the plan, and put the deviation in the log.
- Credit every dataset, model, paper and code you build on, with a source and licence.
- Don't invent references. Check that each citation exists and says what you claim before you add it.
<!-- handoffboard:end -->
